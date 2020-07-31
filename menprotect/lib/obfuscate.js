const print = console.log
const date = new Date()

const functions = require('./funcs')
const funcs = new functions()

const macros = {}
{ // Load macros
    macros.MP_PROTECT = require('./obfuscate/macros/MP_PROTECT')
}

module.exports = function(options) {
    let start = funcs.get_mili_time()

    let keys = {
        vm: Math.floor(Math.random() * 50) + 11,
        byte: Math.floor(Math.random() * 50) + 11,
    }

    let script = options.script || `do end`
    let callback = options.callback || function(){}

    let state = function(body) { // Change in states
        let func = options.state || function(){}
        func({
            body: body,
        })
    }

    let log = function(body, status) { // Logs

        /*
            1: SUCCESS (DEFAULT)
            2: WARNING
            3: ERROR
        */

        let func = options.log || function(){}
        func({
            body: body,
            status: status,
        })
    }

    state('Initializing')

    try { // Scan for macros
        let AST = funcs.parse(script)
        state('Mapping')
        function scan(chunk) {
            Object.keys(chunk).forEach(function(v1) {
                let __chunk = chunk[v1]

                if (__chunk && typeof(__chunk) == 'object') { // Is chunk is valid
                    let type = __chunk.type

                    if (type == 'CallExpression') { // Macro being called
                        let base = __chunk.base
                        let args = __chunk.arguments
                        let func = base.name // Function name (Macro)

                        if (macros[func]) { // Is calling macro
                            macros[func](__chunk) // Call macro with chunk data
                            log(`MACRO USED : "${func}"`)
                        }
                    }

                    scan(__chunk) // Scan chunk descendants
                }
            })
        }

        scan(AST.body) // Start macro scanning

        let source = funcs.minify(AST)
        script = '' // Clear script

        Object.keys(macros).forEach(function(value) { // For each macro, add lua function
            script += `local function ${value}(...)return(...)end\n`
        })

        script += source // Add script back
    } catch (err) {
        return log(`${err.toString()}`, 3)
    }

    state('Compiling function')
    funcs.compile(script).then(function(bytecode) { // Compile script

        state('Deserializing')
        let deserialized = funcs.deserialize(bytecode) // Deserialize bytecode into a proto structure

        state('Generating stream')
        let stream = funcs.reserialize(deserialized, keys) // Convert proto structure into a bytecode stream

        state('Converting')
        let mp_bytecode = funcs.convertstream(stream) // Convert bytecode stream into a string

        state('Building VM')
        let vm = funcs.build_vm({
            proto: deserialized.proto,
            instructions: deserialized.instructions,
            bytecode: mp_bytecode,
        }, keys)

        // print(funcs._2C(bytecode))
        // print(deserialized.proto)

        { // Return
            let time = parseFloat((funcs.get_mili_time() - start).toString().substring(0, 6))
            state('Done !')
            callback({
                script: vm,
                time: time,
            })
        }
    })
}
