##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2011  Kyle Shank (kyle.shank@gmail.com)
# http://www.gnu.org/licenses/agpl.html
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
class Campaign < ActiveRecord::Base
  has_many :donations
  has_many :statuses
  has_many :twitter_statuses
  belongs_to :twitter_account
  has_many :facebook_statuses
  belongs_to :facebook_account

  validates_presence_of :name, :description, :permalink
  validates_uniqueness_of :permalink
  validates_exclusion_of :permalink, :in => %w(account accounts signin signout home facebook_accounts twitter_accounts campaign campaigns dya)
  validates_format_of :permalink, :with => /\A[a-z0-9]+\z/i

  validate :validate_campaign

  def validate_campaign
    if self.twitter_account.nil? and self.facebook_account.nil?
      errors.add(:twitter_account, "at least 1 account must be associated with a Campaign")
      errors.add(:facebook_account, "at least 1 account must be associated with a Campaign")
    else
      errors.add(:twitter_account, "Twitter account can't be changed once donations have been made'") if self.changed.include?("twitter_account_id") and (self.donations.twitter.count > 0)
      errors.add(:facebook_page_uid, "Facebook page can't be changed once donations have been made") if self.changed.include?("facebook_page_uid") and (self.donations.facebook.count > 0)
    end
    if self.premium? and (self.levels == 0)
      errors.add(:levels, "At least one donation level must be chosen")
    end
  end

  scope :desc, -> {order("campaigns.id desc")}
  scope :suggest_for, -> (aid) {select("DISTINCT(campaigns.id),campaigns.*").joins("LEFT JOIN donations ON donations.campaign_id = campaigns.id").where(["donations.account_id != ? AND campaigns.account_id != ?", aid, aid])}
  scope :for_accounts, -> (accounts) { where(conditions_for_accounts(accounts))}

  def self.conditions_for_accounts(accounts)
    conds = []
    accounts.each do |a|
      conds << "campaigns.#{a.class.name.underscore}_id=#{a.id}"
    end
    conds.join(" OR ")
  end

  def to_param
    self.permalink
  end

  def image
    return self.twitter_account.profile_image_url if self.twitter_account && !self.twitter_account.profile_image_url.blank?
    return self.facebook_page["picture"] if self.facebook_page
    "/images/default_campaign.png"
  end

  def facebook_page
    self["facebook_page"].blank? ? nil : JSON.parse(self["facebook_page"])
  end

  def managed_by?(accounts)
    found = false
    accounts.each do |a|
      if (self.twitter_account_id == a.id) or (self.facebook_account_id == a.id)
        found = true
        break
      end
    end
    found
  end

  def levels
    return read_attribute(:levels) if read_attribute(:levels) and (read_attribute(:levels)>0)
    return 7
  end

  def level_gold
    return read_attribute(:level_gold) if read_attribute(:level_gold) and !read_attribute(:level_gold).empty?
    "Gold"
  end

  def level_silver
    return read_attribute(:level_silver) if read_attribute(:level_silver) and !read_attribute(:level_silver).empty?
    "Silver"
  end

  def level_bronze
    return read_attribute(:level_bronze) if read_attribute(:level_bronze) and !read_attribute(:level_bronze).empty?
    "Bronze"
  end

  def levels=(lvls)
    accumulator = 0
    if lvls
      lvls.each do |l|
        accumulator += l.to_i
      end
    end
    write_attribute(:levels, accumulator)
  end

  def upgrade!(token, last4, exp_month, exp_year, type)
    errors.add(:email, "Email required") and return false if self.email.nil? or self.email.empty?
    # Create a Customer
    customer = nil
    if self.customer_id.nil?
      customer = Stripe::Customer.create(
        :card => token,
        :plan => "pro",
        :email => self.email
      )
    else
      customer = Stripe::Customer.retrieve(self.customer_id)
      customer.card = token
      customer.save
    end
    errors.add(:customer_id, "Payment failed") and return false unless (customer and customer.id)
    self.billing_last4 = last4
    self.billing_exp_month = exp_month
    self.billing_exp_year = exp_year
    self.billing_type = type
    self.premium = true
    self.customer_id = customer.id
    save
  end

  def downgrade!
    return false if self.customer_id.nil?
    cu = Stripe::Customer.retrieve(self.customer_id)
    if cu and cu.cancel_subscription
      self.premium = false
      self.customer_id = nil
      save
      return true
    end
    false
  end
end
