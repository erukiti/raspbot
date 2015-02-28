# Commands:
#   \\host\path... - smb://host/path... 形式に変換する

module.exports = (robot) -> 
  robot.hear /(\\\\.*)$/, (msg) ->
    msg.send "smb:" + msg.match[1].replace(/\\/g, "/")
