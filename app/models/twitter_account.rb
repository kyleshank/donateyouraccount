class TwitterAccount < Account
  include RetryHelper
  
  validates_presence_of :screen_name, :secret

  def profile_image_url
    self["profile_image_url"] || "http://a0.twimg.com/a/1294084247/images/default_profile_4_normal.png"
  end

  def url
  "http://twitter.com/#{self.screen_name}"
  end

  def twitter_url
    url
  end

  def recent_tweets
    try_to do
      Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret).user_timeline(self.screen_name, :trim_user => true, :count => 50)
    end
  end

  def retweet(_id)
    try_to do
      Twitter::Client.new(:oauth_token => self.token, :oauth_token_secret => self.secret).retweet(_id)
    end
  end
end