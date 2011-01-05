class DonatedStatus < ActiveRecord::Base
  belongs_to :donation
  belongs_to :status
  
  validates_presence_of :donation, :status

  after_create :retweet

  private

  def retweet
    client = Twitter::Client.new(:oauth_token => self.donation.account.token, :oauth_token_secret => self.donation.account.secret)
    client.retweet(self.status.twitter_status_id)
  end
end
