class AddCampaignDomain < ActiveRecord::Migration
  def change
  	add_column :campaigns, :domain, :string
  	add_column :campaigns, :premium, :boolean, :default => false
  	add_column :campaigns, :levels, :integer, :default => 0
  end
end
