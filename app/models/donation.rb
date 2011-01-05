class Donation < ActiveRecord::Base
  belongs_to :account
  belongs_to :campaign, :class_name => "Account", :foreign_key => "campaign_id"

  has_many :donated_statuses
  has_many :statuses, :through => :donated_statuses

  validates_presence_of :account, :campaign
  validates_uniqueness_of :account_id, :scope =>[:campaign_id]

  scope :for_campaign, lambda {|i| {:conditions => {:campaign_id => i}}}
end
