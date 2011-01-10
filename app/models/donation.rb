class Donation < ActiveRecord::Base
  LEVELS = {
      1 => "Bronze",
      2 => "Silver",
      3 => "Gold"
  }

  belongs_to :account
  belongs_to :campaign

  has_many :donated_statuses
  has_many :statuses, :through => :donated_statuses

  validates_presence_of :account, :campaign
  validates_uniqueness_of :account_id, :scope =>[:campaign_id]

  scope :for_campaign, lambda {|i| {:conditions => {:campaign_id => i}}}
  scope :desc, order("donations.id DESC")
end
