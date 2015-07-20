class Tweet
<<<<<<< HEAD
  ALL_TWEETS = [] 
  attr_accessor :username, :content
  def initialize(username, content)
    @username = username
    @content = content
    ALL_TWEETS.push(self)
  end
 
  def self.all
    ALL_TWEETS
  end
  
end



=======

end
>>>>>>> 7d689702194234ed81b5d8b1dce681fd8dbc8bf8
