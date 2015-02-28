# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot say <text> - えるきち家のゆっくりが <text> を喋る

shellwords = require 'shellwords'
child_process = require 'child_process'

module.exports = (robot) ->
    robot.respond /SAY (.*)$/i, (msg) ->
      child_process.exec "/home/pi/aquestalkpi/AquesTalkPi #{shellwords.escape msg.match[1]} | aplay"

