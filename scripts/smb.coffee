

module.exports = (robot) -> 
  robot.hear /(\\\\.*)$/, (msg) ->
    msg.send "smb:" + msg.match[1].replace(/\\/g, "/")
