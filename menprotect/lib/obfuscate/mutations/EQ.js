const print = console.log

const functions = require('../../funcs')
const funcs = new functions()
const handle = 'BinaryExpression'

const pole = {
    ['==']: '~=',
    ['~=']: '==',
}

module.exports = {
    init: function(mutations) {
        funcs.mutation_handler(mutations, handle)
        mutations[handle].connect(function(data) {

            let options = data.options
            let stats = data.stats
            let chunk = data.subchunk[data.idx]

            if (chunk.operator) {

                if (options.max_mutations.enabled) {
                    if (stats.mutations >= options.max_mutations.amount) return
                }
                
                stats.mutations++

                data.subchunk[data.idx] = {
                    type: 'UnaryExpression',
                    operator: 'not',
                    argument: {
                        type: chunk.type,
                        operator: pole[chunk.operator],
                        left: chunk.left,
                        right: chunk.right,
                    },
                }

            }
        })
    },
}
