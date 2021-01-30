const Imap = require('imap');
const fs = require('fs');
const os = require('os');
const admin = require('firebase-admin');
const path = require('path');
const {Base64Decode} = require('base64-stream');
const configuration = require('../settings');

const getAttachment = async (data, context) => {

    const imap = new Imap({
        user: configuration.imapUser,
        password: configuration.imapPassword,
        host: configuration.imapHost,
        port: configuration.imapPort,
        tls: configuration.imapTls
    });

    const toUpper = (thing) => thing && thing.toUpperCase ? thing.toUpperCase() : thing;

    const getBucket = () => admin.storage().bucket(configuration.importBucket);

    const findAttachmentParts = (struct, attachments) => {
        attachments = attachments ||  [];
        for (let i = 0, len = struct.length, r; i < len; ++i) {
            if (Array.isArray(struct[i])) {
                findAttachmentParts(struct[i], attachments);
            } else {
                if (struct[i].disposition && ['INLINE', 'ATTACHMENT'].indexOf(toUpper(struct[i].disposition.type)) > -1) {
                    attachments.push(struct[i]);
                }
            }
        }
        return attachments;
    };

    const buildAttMessageFunction = (attachment) => {
        //const filename = attachment.params.name;
        const filename = "file.xlsx";
        const contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        const metadata = {
            contentType: contentType,
            contentDisposition: `attachment; filename="${filename}"`
        };
        const tempLocalResultFile = path.join(os.tmpdir(), filename);
        const encoding = attachment.encoding;

        return function (msg, seqno) {
            const prefix = '(#' + seqno + ') ';
            msg.on('body', (stream, info) => {
                //Create a write stream so that we can stream the attachment to file;
                console.log(prefix + 'Streaming this attachment to file', tempLocalResultFile, info);
                const writeStream = fs.createWriteStream(tempLocalResultFile);
                writeStream.on('finish', () =>  {
                    console.log(prefix + 'Done writing to file %s', tempLocalResultFile);
                });

                //stream.pipe(writeStream); this would write base64 data to the file.
                //so we decode during streaming using
                if (toUpper(encoding) === 'BASE64') {
                    //the stream is base64 encoded, so here the stream is decode on the fly and piped to the write stream (file)
                    stream.pipe(new Base64Decode()).pipe(writeStream);
                } else  {
                    //here we have none or some other decoding streamed directly to the file which renders it useless probably
                    stream.pipe(writeStream);
                }
            });
            msg.once('end', () => {
                getBucket().upload(tempLocalResultFile, {destination: filename, metadata: metadata}, () => {
                    fs.unlinkSync(tempLocalResultFile);
                    console.log(prefix + 'Finished attachment %s', tempLocalResultFile);
                });
            });
        };
    };


    imap.once('ready', () => {
        imap.openBox('INBOX', false, (err, box) => {
            if (err) throw err;
            imap.search([ 'UNSEEN', ['SINCE', 'May 20, 2010'] ], (err, results) => {
                if (err) throw err;
                if(results.length === 0) {
                    console.log('There is no new message');
                    imap.end();
                    return;
                }
                const f = imap.fetch(results[0], {
                    bodies: ['HEADER.FIELDS (FROM TO SUBJECT DATE)'],
                    struct: true,
                    markSeen: true
                });
                f.on('message', (msg, seqno) => {
                    console.log('Message #%d', seqno);
                    const prefix = '(#' + seqno + ') ';
                    msg.on('body', (stream, info) => {
                        let buffer = '';
                        stream.on('data', (chunk) => {
                            buffer += chunk.toString('utf8');
                        });
                        stream.once('end', () => {
                            console.log(prefix + 'Parsed header: %s', Imap.parseHeader(buffer));
                        });
                    });
                    msg.once('attributes', (attrs) => {
                        const attachments = findAttachmentParts(attrs.struct);
                        console.log(prefix + 'Has attachments: %d', attachments.length);
                        for (let i = 0, len = attachments.length; i < len; ++i) {
                            const attachment = attachments[i];
                            /*This is how each attachment looks like {
                                partID: '2',
                                type: 'application',
                                subtype: 'octet-stream',
                                params: { name: 'file-name.ext' },
                                id: null,
                                description: null,
                                encoding: 'BASE64',
                                size: 44952,
                                md5: null,
                                disposition: { type: 'ATTACHMENT', params: { filename: 'file-name.ext' } },
                                language: null
                              }
                            */
                            console.log(prefix + 'Fetching attachment %s', attachment.params.name);
                            var f = imap.fetch(attrs.uid, { //do not use imap.seq.fetch here
                                bodies: [attachment.partID],
                                struct: true
                            });
                            //build function to process attachment message
                            f.on('message', buildAttMessageFunction(attachment));
                        }
                    });
                    msg.once('end', () => {
                        console.log(prefix + 'Finished email');
                    });
                });
                f.once('error', (err) => {
                    console.log('Fetch error: ' + err);
                });
                f.once('end', () => {
                    console.log('Done fetching all messages!');
                    imap.end();
                });
            });
        });
    });

    imap.once('error', (err) => {
        console.log(err);
    });

    imap.once('end', () => {
        console.log('Connection ended');
    });

    imap.connect();

};

module.exports = getAttachment;