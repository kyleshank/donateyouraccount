class Donation < ActiveRecord::Base
  LEVELS = {
      "Bronze" => 1,
      "Silver" => 2,
      "Gold" => 4
  }

  belongs_to :account
  belongs_to :campaign

  has_many :donated_statuses
  has_many :statuses, :through => :donated_statuses

  validates_presence_of :account, :campaign, :level
  validates_uniqueness_of :account_id, :scope =>[:campaign_id]
  validates_inclusion_of :level, :in => [1,2,4]

  scope :for_campaign, lambda {|i| {:conditions => {:campaign_id => i}}}
  scope :desc, order("donations.id DESC")
  scope :gold, {:conditions => {:level => LEVELS["Gold"]}}
  scope :silver, {:conditions => {:level => LEVELS["Silver"]}}
  scope :bronze, {:conditions => {:level => LEVELS["Bronze"]}}
  scope :for_levels, lambda {|levels| {:conditions => levels.collect{|l| "donations.level = #{l}"}.join(" OR ")}}
end
