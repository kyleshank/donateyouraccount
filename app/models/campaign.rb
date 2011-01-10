class Campaign < ActiveRecord::Base
  belongs_to :account
  has_many :donations, :include => :account
  has_many :statuses

  validates_presence_of :account, :description

  def to_param
    self.account.screen_name
  end
end
