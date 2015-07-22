require_relative "../../config/environment"
require_relative "../models/tweet.rb"
class ApplicationController < Sinatra::Base
  
  set :views, "app/views"
  set :public, "public"
  
  get "/" do
    @tweet = Tweet.new("Richard Stamina", "Rold Gold makes me feel like cold mold")
    erb :tweets
  end
  get "/submit_tweet" do
    erb :index
  end
  post "/submit_tweet" do
    tweet_content = params[:tweet]
    hashtags = tweet_content.scan(/#([^\s]+)/).flatten
    hashtags = hashtags.to_a
    hashtags.uniq!
    hashtag_urls = []
    hashtags.each do |tag|
      hashtag_url = '<a href="/hashtag/HASHTAGHEREPLEASE" class="hashtag">#HASHTAGHEREPLEASE</a>'
      hashtag_url = hashtag_url.gsub("HASHTAGHEREPLEASE", tag)
      hashtag_urls.push(hashtag_url)
    end
    hashtag_urls.each_with_index do |url, i|
      puts url.inspect
      puts hashtags[i].inspect
      tweet_content = tweet_content.gsub("#" + hashtags[i], url)
    end
    @tweet = Tweet.new(params[:username], tweet_content)
    erb :results
  end
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
  
end