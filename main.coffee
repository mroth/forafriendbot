Sugar = require('sugar')
Colors = require('colors')
Twit = require('twit')
TweetWrapper = require('./lib/tweet_wrapper')

T = new Twit(
  consumer_key:         process.env.CONSUMER_KEY
  consumer_secret:      process.env.CONSUMER_SECRET
  access_token:         process.env.OAUTH_TOKEN
  access_token_secret:  process.env.OAUTH_TOKEN_SECRET
)

stream = T.stream('statuses/filter', { track: 'asking for a friend' })

stream.on 'tweet', (tweet) ->
  console.log tweet.text

  tw = new TweetWrapper(tweet)
  disqualified = switch
    when tw.isRetweet()         then "IS RETWEET"
    when tw.isReply()           then "IS REPLY"
    when tw.containsMentions()  then "CONTAINS MENTION(S)"
    else null
  if disqualified?
    console.log "DISQUALIFIED - #{disqualified}".red
    return false

  match = (/(^.*\?)\s+(?:I'm |I am )?asking for a .*friend/i).exec tweet.text
  console.log "MATCHED!".green if match?
  console.log "NO match!".yellow unless match?
