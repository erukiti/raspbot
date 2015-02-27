dice = require '../dice'

module.exports = (robot) ->
  robot.hear /(.*[0-9]d[0-9].*)$/i, (msg) ->
    rolled = dice.parse(msg.match[1])
    msg.send "#{rolled}"
