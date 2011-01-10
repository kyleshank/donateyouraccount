class Account < ActiveRecord::Base
  has_many :donations, :dependent => :destroy
  has_one :campaign

  validates_presence_of :name, :screen_name, :uid, :token, :secret
  validates_uniqueness_of :screen_name, :uid

  def profile_image_url
    @profile_image_url || "http://a0.twimg.com/a/1294084247/images/default_profile_4_normal.png"
  end

  def twitter_url
    "http://twitter.com/#{self.screen_name}"
  end
end
