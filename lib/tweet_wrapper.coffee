require('sugar')
Tt = require('twitter-text')

class TweetWrapper
  constructor: (@tweet) ->

  isRetweet: ->
    @tweet.text.startsWith("RT")

  isReply: ->
    @tweet.text.startsWith("@")

  containsMentions: ->
    Tt.extractMentions(@tweet.text).length > 0

module.exports = TweetWrapper
