module.exports = function(s) {
    let ns = ""
    for (let i = 0; i < s.length; i++) {
        ns += "\\" + s.charCodeAt(i)
    }
    return ns
}
