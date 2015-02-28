cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.hear /LGTM/i, (msg) ->
    msg.http('http://www.lgtm.in/g').get() (err, res, body) ->
      $ = cheerio.load(body)
      url = $('#imageUrl').val()
      msg.send url