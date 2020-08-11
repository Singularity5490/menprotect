const print = console.log
const fs = require("fs")

const menprotect = require('./menprotect')
const obfuscator = new menprotect()

obfuscator.obfuscate({
    script: fs.readFileSync("./Script.lua", {encoding: "binary"}),

    callback: function(data) {
        print(data.stats)

        console.log('\x1b[36m' + `Obfuscated in ${data.time} ms!` + '\x1b[0m')
        fs.writeFileSync("./Out.lua", data.script)
    },
    
    options: {
        max_mutations: {
            enabled: true,
            amount: 50,
        },
    },

    notes: `290478444347785217`, // Discord ID
})
