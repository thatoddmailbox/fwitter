require_relative "../../config/environment"
require_relative "../models/tweet.rb"
class ApplicationController < Sinatra::Base
  
  set :views, "app/views"
  set :public, "public"
  
  get "/" do
    @tweet_1 = Tweet.new("Richard Stamina", "Rold Gold makes me feel like cold mold")
    erb :tweets
  end
  
end