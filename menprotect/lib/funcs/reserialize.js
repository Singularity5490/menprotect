const print = console.log

const functions = require('../funcs')
const funcs = new functions()

module.exports = function(data, keys) {
    let proto = data.proto
    let instructions = data.instructions
    let vmkey = keys.vm

    let stream = []

    { // Stream functions
        function push(w) {
            stream.push(w)
        }

        function add_byte(n) {
            push(n)
        }

        function add_bytes(n) {
            n = n.toString()
            for (let i = 0; i < n.length; i++) {
                add_byte(parseInt(n[i]))
            }
        }

        function add_string(string) {
            for (let i = 0; i < string.length; i++) {
                push(string.charCodeAt(i, i))
            }
        }

        function add_type(x) {
            if (typeof(x) == 'string') {
                add_byte(1) // Code for string
                add_byte(x.length) // Add length
                add_string(x)
            } else if (typeof(x) == 'number') {
                add_byte(2) // Code for number
                add_byte(x.toString().length)
                add_bytes(x)
            } else if (typeof(x) == 'boolean') {
                add_byte(3) // Code for boolean
                add_byte(x == true && 1 || 0)
            } else { // NULL
                add_byte(0) // Code for nil
            }

        }
    }

    function add_chunk(chunk) {
        add_byte(chunk.Args) // Args
        add_byte(chunk.Upvals) // Upvals

        { // Add instructions
            let c_instrutions = Object.keys(chunk.Instr) // Instructions index
            add_type(c_instrutions.length) // Add amount of instruction registers to stream

            for (let i = 1; i <= c_instrutions.length; i++) { // For each register, add data to stream
                let c_register = Object.keys(chunk.Instr[i]) // Register index
                add_byte(c_register.length) // Amount of values in register

                c_register.forEach(function(index) {
                    let value = chunk.Instr[i][index] // Register value
                    add_type(value) // Add value to stream
                })
            }
        }

        { // Add constants
            let c_constants = Object.keys(chunk.Const) // Constants index
            add_type(c_constants.length) // Add amount of constants to stream

            for (let i = 1; i <= c_constants.length; i++) {
                let constant = chunk.Const[i]
                add_type(constant)
            }
        }

        { // Add protos
            let c_protos = Object.keys(chunk.Proto) // Protos index
            add_type(c_protos.length) // Amount of protos

            for (let i = 1; i <= c_protos.length; i++) { // For each proto
                let proto = chunk.Proto[i]
                add_chunk(proto) // Add proto to stream
            }
        }

    }

    function add_payload(queue) {
        add_byte(queue.length)
        for (let i = 0; i < queue.length; i++) {
            add_type(funcs.encrypt(queue[i], vmkey))
        }
    }

    add_string('menprotect|') // Header
    add_byte(vmkey) // VM key
    
    add_payload(['__index', '__newindex']) // General VM strings

    add_chunk(proto) // Decode chunk(s)

    return stream
}
