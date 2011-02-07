class Campaign < ActiveRecord::Base
  belongs_to :account
  has_many :donations, :include => :account
  has_many :statuses

  validates_presence_of :account, :description

  scope :desc, :order => "campaigns.id desc"
  scope :suggest_for, lambda {|aid| {:select => "DISTINCT(campaigns.id),campaigns.*", :joins => "LEFT JOIN donations ON donations.campaign_id = campaigns.id", :conditions => ["donations.account_id != ? AND campaigns.account_id != ?", aid, aid]}}
  
  def to_param
    self.account.screen_name
  end
end
