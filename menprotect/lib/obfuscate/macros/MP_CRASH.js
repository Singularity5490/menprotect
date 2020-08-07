const print = console.log

module.exports = function(chunk) {
    let args = chunk.arguments

    args[0] = {
        type: 'StringLiteral',
        value: null,
        raw: '((function()while true do end end)())',
    }
}
