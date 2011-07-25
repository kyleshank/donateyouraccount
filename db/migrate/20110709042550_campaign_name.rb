class CampaignName < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :name, :string
    add_column :campaigns, :image, :string
    Campaign.reset_column_information
    TwitterAccount.all.each do |t|
      t.campaign.update_attributes({:name => t.name, :image => t.profile_image_url})
    end
  end

  def self.down
    remove_column :campaigns, :name
    remove_column :campaigns, :image
  end
end
