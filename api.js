const express = require("express");
const fs = require("fs");
const app = express();
app.use(express.json({limit: "1gb"}));
const config = require("./config.json");
fs.readdirSync("./routes").forEach(function(name) {
    let Module = require(`./routes/${name.split(".")[0]}`);
    app.use(`/${Module.name}`, Module.router);
});

process.env = config;

app.listen(process.env.port);