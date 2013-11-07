class TweetLimiter
  constructor: (@timeout = 300) ->

  okayToTweet: ->
    return true if !@lastTweet?
    (new Date() - @lastTweet) > @timeout*1000

  set: ->
    @lastTweet = new Date()

module.exports = TweetLimiter
