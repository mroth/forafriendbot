Sugar = require('sugar')
Colors = require('colors')
Twit = require('twit')
TweetWrapper = require('./lib/tweet_wrapper')
TweetLimiter = require('./lib/tweet_limiter')

T = new Twit(
  consumer_key:         process.env.CONSUMER_KEY
  consumer_secret:      process.env.CONSUMER_SECRET
  access_token:         process.env.ACCESS_TOKEN
  access_token_secret:  process.env.ACCESS_TOKEN_SECRET
)
limit = process.env.LIMIT || 3600
console.log "Limiting posting with limiter of #{limit} seconds..."
limiter = new TweetLimiter(limit)

stream = T.stream('statuses/filter', { track: 'asking for a friend' })

stream.on 'tweet', (tweet) ->
  console.log tweet.text

  tw = new TweetWrapper(tweet)
  disqualified = switch
    when tw.isRetweet()         then "IS RETWEET"
    when tw.isReply()           then "IS REPLY"
    when tw.containsMentions()  then "CONTAINS MENTION(S)"
    when tw.containsLinks()     then "CONTAINS LINK(S)"
    else null
  if disqualified?
    console.log "DISQUALIFIED - #{disqualified}".red
    return false

  match = (/(^.*\?)\s+(?:I'm |I am )?asking for a .*friend/i).exec tweet.text
  console.log "MATCHED!".green if match?
  console.log "NO match!".yellow unless match?

  fs = require('fs')
  if match?
    fs.appendFileSync('tweetlog.txt', new Date().toTimeString() + ":\n" + tweet.text + "\n\n")
    if limiter.okayToTweet()
      console.log "TWEETING!".blue
      limiter.set()
      T.post 'statuses/update', { status: tweet.text }, (err, reply) ->
        if !err?
          console.log " ...posted successfully as #{reply.id}".blue
        else
          console.log err
    else
      console.log "not tweeting because of limit...".blue
