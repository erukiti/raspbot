# Commands:
#   <m>d<n> - ダイス振る ex. 3d6 + 1d10 + 3

dice = require '../dice'

module.exports = (robot) ->
  robot.hear /([0-9d()+\-*\/>=<]+)/i, (msg) ->
    rolled = dice.parse(msg.match[1])
    msg.send "#{rolled}"
