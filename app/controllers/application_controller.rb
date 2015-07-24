require_relative "../../config/environment"
require_relative "../models/tweet"
require_relative "../models/user"

class ApplicationController < Sinatra::Base
  
  enable :sessions
  set :session_secret, 'fwitter is awesome and this is a cookie secret'
  
  set :views, "app/views"
  set :public_folder, "public"
  
  before do
    if session[:logged_in] == nil
      session[:logged_in] = false
    end
  end
  
  get "/" do
    erb :index, :layout => :layout
  end
  
  get "/logout" do
    session[:logged_in] = false
    session[:user_id] = -1
    
    redirect to("/")
  end
  
  get "/login" do
    erb :login, :layout => :layout
  end
  
  post "/login" do
    user = User.find_by_username(params[:username]) #.where(["lower(username) = ?", params[:username].downcase])  #where(username: params[:username])
    if (user.password != params[:password])
      return "The username or password is incorrect."
    end
    
    session[:logged_in] = true
    session[:user_id] = user.id
    
    redirect to("/")
  end
  
  get "/signup" do
    erb :signup, :layout => :layout
  end
  
  post "/signup" do
    # todo: serverside validation
    
    user = User.new({:username => params[:username], :email => params[:email]})
    user.password = params[:password] # "But WAIT!" you say! The password isn't hashed!
                                      # This actually does hash it... check the User model's password writer method
    user.save
    
    # todo: email
    
    session[:logged_in] = true
    session[:user_id] = user.id
    
    redirect to("/")
  end
  
  get "/hashtag/:hashtag" do
    erb :hashtag, :layout => :layout
  end
  
  get "/user/:user" do
    erb :user, :layout => :layout
  end
  
  post "/submit_tweet" do
    if not session[:logged_in]
      redirect to("/login")
    end
    
    tweet_content = params[:tweet]
    
    # save it
    @tweet = Tweet.new({
      :user_id => session[:user_id],
      :content => tweet_content
    })
    @tweet.save
    
    #erb :results
    redirect to("/")
  end
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
    def parse_tweet(tweet_content)
      tweet_content = Rack::Utils.escape_html(tweet_content)
      # hashtag parsing
      hashtags = tweet_content.scan(/(?<!&)#(\w+)/).flatten
      hashtags = hashtags.to_a
      hashtags.uniq!
      hashtag_urls = []
      hashtags.each do |tag|
        hashtag_url = '<a href="/hashtag/HASHTAGHEREPLEASE" class="hashtag">#HASHTAGHEREPLEASE</a>'
        hashtag_url = hashtag_url.gsub("HASHTAGHEREPLEASE", tag)
        hashtag_urls.push(hashtag_url)
      end
      hashtag_urls.each_with_index do |url, i|
        tweet_content = tweet_content.gsub("#" + hashtags[i], url)
      end

      # mention parsing
      mentions = tweet_content.scan(/(?<!&)@(\w+)/).flatten
      mentions = mentions.to_a
      mentions.uniq!
      mention_urls = []
      mentions.each do |tag|
        mention_url = '<a href="/user/USERHEREPLEASE" class="user">@USERHEREPLEASE</a>'
        mention_url = mention_url.gsub("USERHEREPLEASE", tag)
        mention_urls.push(mention_url)
      end
      mention_urls.each_with_index do |url, i|
        tweet_content = tweet_content.gsub("@" + mentions[i], url)
      end

      return tweet_content
    end
  end
  
end