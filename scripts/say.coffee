# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot say <text> - えるきち家のゆっくりが <text> を喋る

shellwords = require 'shellwords'
exec = require('child_process').exec
Slack = require 'slack-node'
slack = new Slack process.env.ERUKITI_SLACK_TOKEN
# bot は files.upload できないので、人間の token を取って使う

module.exports = (robot) ->
    robot.respond /SAY (.*)$/i, (msg) ->
      word = shellwords.escape msg.match[1].replace(/[\r\n]/g, "")
      exec "/home/pi/aquestalkpi/AquesTalkPi #{word} | aplay"
      exec "/home/pi/aquestalkpi/AquesTalkPi #{word} | lame - out.mp3"
      getChannelFromName msg.message.room, (err, id) ->
        if err
          console.dir err
          return
        exec "curl -F file=@out.mp3 -F filename=voice.mp3 -F channels=#{id} -F token=#{process.env.ERUKITI_SLACK_TOKEN} https://slack.com/api/files.upload"

    getChannelFromName = (channelName, callback) ->
      slack.api "channels.list", exclude_archived: 1, (err, response) ->
        if err
          return callback err

        if !response.ok
          return callback response.error
        for val, i in response.channels
          if val.name == channelName
            console.dir val
            return callback null, val.id

        return callback err 

