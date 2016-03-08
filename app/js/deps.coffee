exports._ = window._ ? require 'underscore'
_.str = require 'underscore.string'
_.mixin _.str.exports()
exports.$ = exports.jQuery = window.jQuery
exports.rx = rx = window.rx
exports.bind = bind = rx.bind
exports.rxt = rxt = rx.rxt
exports.R = rxt.tags
exports.moment = window.moment
exports.hasher = window.hasher
exports.Router = window.Router
