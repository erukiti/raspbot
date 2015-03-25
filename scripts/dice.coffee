# Commands:
#   <m>d<n> - ダイス振る ex. 3d6 + 1d10 + 3

dice = require '../dice'

module.exports = (robot) ->
  robot.hear /^([0-9dx()+\-*\/%\. \t]+)$/i, (msg) ->
    expr = msg.match[1]
    rolled = dice.parse(expr)
    msg.send "#{rolled}" if expr != rolled
