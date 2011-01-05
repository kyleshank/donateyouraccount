class Account < ActiveRecord::Base
  has_many :donations, :dependent => :destroy
  has_many :donors, :class_name => "Donation", :foreign_key => "campaign_id", :include => :account, :dependent => :destroy
  has_many :statuses

  validates_presence_of :name, :screen_name, :uid, :token, :secret
  validates_uniqueness_of :screen_name, :uid

  def to_param
    self.screen_name
  end
end
