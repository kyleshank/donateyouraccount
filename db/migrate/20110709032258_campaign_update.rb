class Campaign < ActiveRecord::Base
  belongs_to :account
end

class CampaignUpdate < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :permalink, :string
    Account.reset_column_information
    Campaign.reset_column_information
    Campaign.all.each do |c|
        c.update_attribute(:permalink, c.account.screen_name)
    end
    rename_column :campaigns, :account_id, :twitter_account_id
    add_column :campaigns, :facebook_account_id, :integer
    add_column :campaigns, :facebook_page_uid, :string
  end

  def self.down
    remove_column :campaigns, :permalink, :string
    rename_column :campaigns, :twitter_account_id, :account_id
    remove_column :campaigns, :facebook_account_id
    remove_column :campaigns, :facebook_page_uid
  end
end
