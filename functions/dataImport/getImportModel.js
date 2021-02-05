
const getImportModel = (req, res) => {
    res.status(200).send({name: "Elit", format: "formattedDate"});
};

module.exports = getImportModel;