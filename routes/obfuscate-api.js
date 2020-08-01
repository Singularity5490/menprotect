const menprotect = require("../menprotect");
const express = require("express");
const obfuscator = new menprotect();
const router = new express.Router();
const Utils = require("../utils");
router.post("/", function(req, res) {
    Utils.GetCollection(async function(collection, client) {
        let Doc = await collection.findOne({
            Key: req.body.key
        })
        if (Doc) {
            obfuscator.obfuscate({
                script: req.body.script || "do end",
                callback: function(data) {
                    res.end(data.script);
                },
                log: function(info) {
                    if (info.status == 4) {
                        res.status(400).end(info.body);
                    };
                }
            });
        } else {
            res.status(400).end("");
        };
        client.close();
    })
});

module.exports = {
    name: "obfuscate",
    router: router
};