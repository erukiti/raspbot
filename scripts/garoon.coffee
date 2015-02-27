# Description:
#   Garoon
#
# Dependencies:
#   cron
#   zombie
#   csv
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   erukiti

# settings = require '../raspbot-settings.json'
# cron = require('cron').CronJob
# Browser = require 'zombie'
# csv = require 'csv'

# module.exports = (robot) ->
#   # new cron '0 */15 * * * *', () =>

#   schedule = 
#   [
#     {
#       start: new Date('2015/03/02' + " " + '12:30:00')
#       end: new Date('2015/03/02' + " " + '13:00:00')
#       title: 'ほげ'
#     }
#   ]
#   robot.brain.set "schedule", schedule

#   robot.send settings.PRIVATE_ROOM, "hoge"
#   # , null, true, "Asia/Tokyo"

