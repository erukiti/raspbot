# Commands:
#   <m>d<n> - ダイス振ります ex. 3d6 + 1d10 + 3

dice = require '../dice'

module.exports = (robot) ->
  robot.hear /(.*[0-9]d[0-9].*)$/i, (msg) ->
    rolled = dice.parse(msg.match[1])
    msg.send "#{rolled}"
