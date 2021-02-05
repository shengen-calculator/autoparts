
const getLogInfo = (req, res) => {
    res.status(200).send({name: "Elit", format: "formattedDate"});
};

module.exports = getLogInfo;