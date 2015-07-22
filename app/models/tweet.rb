class Tweet < ActiveRecord::Base
  attr_accessor :username, :content
  def initialize(username, content)
    @username = username
    @content = content
  end
end

