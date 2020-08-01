const menprotect = require('./menprotect')
const obfuscator = new menprotect()
const fs = require("fs")
obfuscator.obfuscate({
    script: fs.readFileSync("./Script.lua", {encoding: "binary"}),
    callback: function(data) {
        console.log('\x1b[36m' + `Obfuscated in ${data.time} ms!` + '\x1b[0m')
        fs.writeFileSync("./Out.lua", data.script)
    },
})