# Tweet Density

----

Small Sinatra app to show you a user's number of tweets by time of day published.  Publishes data to json, xml, or an html chart rendered using [Highcharts](http://www.highcharts.com/).

Some sample URL formats:

``` 
/tweetdensity/?handle=gruber&count=500&type=xml
/tweetdensity/?handle=gruber&count=50&type=json
/tweetdensity/?handle=gruber&count=100&type=html
```

Configuration
----

Requires the following Ruby gems installed: oauth, sinatra, builder

I've used Shotgun and Unicorn to run the app, but it should work with other rack-based servers.

You'll need to aquired your own Twitter API key from https://dev.twitter.com/apps and place the values in the `config/twitter_config.yml` file.  A sample file is included.
