const MongoDB = require("mongodb");

async function GetCollection(callback) {
    const Client = new MongoDB.MongoClient(process.env.MONGO_URL, {
        useUnifiedTopology: true
    });
    await Client.connect(); 
    let DB = Client.db("menprotect");
    callback(DB.collection("keys"), Client);
};

module.exports = {
    GetCollection: GetCollection
}