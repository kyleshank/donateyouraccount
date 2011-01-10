class Status < ActiveRecord::Base
  belongs_to :campaign
  has_many :donated_statuses
  has_many :donations, :through => :donated_statuses

  validates_presence_of :campaign, :body
  validates_length_of :body, :maximum=>140, :minimum => 1

  scope :donated_through_account, lambda {|a| {:joins => "INNER JOIN donated_statuses ON donated_statuses.status_id = statuses.id INNER JOIN donations ON donations.id = donated_statuses.donation_id INNER JOIN accounts ON donations.account_id = accounts.id ", :conditions => ["accounts.id = ?", a.id], :group => "statuses.id" } }  
  scope :desc, order("statuses.id desc")


  before_create do
    tweet = Twitter::Client.new(:oauth_token => self.campaign.account.token, :oauth_token_secret => self.campaign.account.secret)
    response = tweet.update(self.body)
    self.twitter_status_id = response["id"]
  end

  after_create do
    self.delay.publish
  end

  def publish
    unless self.twitter_status_id.blank?
      self.campaign.donations.each do |donation|
        donation.donated_statuses.create(:status => self)
      end
    end
  end

  def twitter_permalink
    "http://twitter.com/#{self.campaign.account.screen_name}/statuses/#{self.twitter_status_id}"
  end
end
