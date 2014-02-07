class AddCampaignEmail < ActiveRecord::Migration
  def change
  	add_column :campaigns, :email, :string
  end
end
