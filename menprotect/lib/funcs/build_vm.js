const print = console.log

const functions = require('../funcs')
const funcs = new functions()
const vmfiles = '../obfuscate/vm/'

module.exports = function(data, keys) {
    let proto = data.proto
    let instructions = data.instructions
    let bytecode = data.bytecode
    let mapping = data.mapping

    let build = ''
    { // Functions
        function add_source(what, ...args) {
            let data = require(`../obfuscate/vm/${what}`)
            build += data(args)
        }

        function add(string) {
            build += string
        }

        function add_opcode(opcode, ...args) {
            let data = require(`../obfuscate/vm/opcodes/${opcode}`)
            build += data(args)
        }
    }

    { // Build VM
        add_source('variables')
        add_source('parser', mapping, keys)
        add_source('init')

        { // Add opcodes
            function add_opcodes() {
                let first = true
                let keyword = 'if'

                let n = 0
                Object.keys(instructions).forEach(function(real_opcode) {
                    n++

                    let opcode = instructions[real_opcode]

                    add(`${keyword} Enum == ${opcode} then\n`)
                    add_opcode(real_opcode, keys, instructions)
                    if (first) {
                        first = false
                        keyword = 'elseif'
                    }
                })

                add(`\nend`)
            }
        }

        add_opcodes()
        add_source('end')
    }

    { // Replace stuff
        let used = []
        function ranvar(l) {
            l = l || 1
            let variable = funcs.randomstring({
                length: l,
                charset: 'alphabetic',
            })
            if (used[variable]) {
                return ranvar(l)
            }
            used[variable] = true
            return variable
        }

        let strings = {
            'O_INSTR': ranvar(),
            'O_CONST': ranvar(),
            'O_PROTO': ranvar(),
            'O_ENUM': ranvar(),
            'O_VALUE': ranvar(),
            'O_ARGS': ranvar(),
            'O_UPVALS': ranvar(),
        }

        Object.keys(strings).forEach(function(index) {
            let value = strings[index]
            build = build.split(index).join(value)
        })
    }

    let secure_byte = funcs._2C(funcs.encrypt(bytecode, keys.byte))

    return `--[[
    This script was obfuscated using menprotect v1.0.0 by elerium:tm:
--]]
return(function()${funcs.minify(build)};end)()("${secure_byte}");
`
}
