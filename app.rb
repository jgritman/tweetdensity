require 'oauth'
require 'sinatra'
require 'json'
require 'yaml'

CONFIG = YAML::load_file ('config/twitter_config.yml')

# Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
def prepare_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new("APIKey", "APISecret",
    { :site => "http://api.twitter.com",
      :scheme => :header
    })
  # now create the access token object from passed values
  token_hash = { :oauth_token => oauth_token,
                 :oauth_token_secret => oauth_token_secret
               }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  return access_token
end
 
# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
AccessToken = prepare_access_token(CONFIG['oauth_key'], CONFIG['oauth_secret'])

def load_counts(handle, count)
  tweet_counts = {}
  24.times {|i| tweet_counts[i] = 0}
  page_count = (count / 200)
  page_count.times do |i| 
    last_page = add_to_counts(tweet_counts,handle,200,i+1)
    return tweet_counts if last_page
  end
  add_to_counts(tweet_counts,handle,count % 200,page_count+1)
  tweet_counts
end

def add_to_counts(tweet_counts, handle, count, page)
  request_url =  "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{handle}&count=#{count}&page=#{page}&trim_user=true"
  response = AccessToken.request(:get,request_url)
  tweet_timeline = JSON.parse(response.body)
  tweet_timeline.each do |tweet|
    hour = Time.parse(tweet['created_at']).hour
    tweet_counts[hour] += 1
  end
  tweet_timeline.count < count  #last page
end

def render_xml(counts) 
  builder do |xml|
    xml.tweetdensity do
      @counts.each do |k,v| 
        xml.data do
          xml.hour ('%02d' % k)
          xml.count v
        end
      end
    end
  end
end

def render_json(counts)
  data = @counts.collect { |k,v| {:hour => k, :count => v}}
  {:tweetdensity=>{:data=>data}}.to_json
end

class WebApp < Sinatra::Base
  get '/tweetdensity/' do
    @counts = load_counts(params[:handle],params[:count].to_i)
    case params[:type]
    when 'xml'
      content_type :xml      
      render_xml @counts
    when 'json'
      content_type :json
      render_json @counts
    when 'html'
      erb :chart
    else
      error(500,"The type #{params[:type]} is unsupported")
    end
  end
end