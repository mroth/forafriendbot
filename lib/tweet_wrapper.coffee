require('sugar')

class TweetWrapper
  constructor: (@tweet) ->

  isRetweet: ->
    @tweet.text.startsWith("RT")

  isReply: ->
    @tweet.text.startsWith("@")

  containsMentions: ->
    @tweet.entities.user_mentions.length > 0

  containsLinks: ->
    @tweet.entities.urls.length > 0

module.exports = TweetWrapper
