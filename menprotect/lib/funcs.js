module.exports = class funcs {
    constructor() {
        this.xor = require('./funcs/xor')
        this.compile = require('./funcs/compile')
        this._2C = require('./funcs/_2C')
        this.get_mili_time = require('./funcs/get_mili_time')
        this.convertstream = require('./funcs/convertstream')
        this.randomstring = require('randomstring').generate
        this.tohex = function(string) {
            return Buffer.from(string, 'utf8').toString('hex');
        }

        this.minify = require('./funcs/minify').minify
        this.parse = require('luaparse').parse
        this.deserialize = require('./funcs/deserialize')
        this.reserialize = require('./funcs/reserialize')
        this.build_vm = require('./funcs/build_vm')

        this.encrypt = function(s, k) {
            let cs = ''
            for (let i = 0; i < s.length; i++) {
                cs += String.fromCharCode(this.xor(s.charCodeAt(i), k))
            }
            return cs
        }
    }
}
