class DonatedStatus < ActiveRecord::Base
  belongs_to :donation
  belongs_to :status
  
  validates_presence_of :donation, :status

  validates_uniqueness_of :status_id, :scope => [:donation_id]

  after_create :retweet

  private

  def retweet
    retries = 0
    while retries < 5
      begin
        client = Twitter::Client.new(:oauth_token => self.donation.account.token, :oauth_token_secret => self.donation.account.secret)
        client.retweet(self.status.twitter_status_id)
        break
      rescue Exception
        retries += 1
      end
    end
  end
end
