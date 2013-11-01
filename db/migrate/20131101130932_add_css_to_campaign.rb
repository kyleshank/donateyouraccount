class AddCssToCampaign < ActiveRecord::Migration
  def change
  	add_column :campaigns, :css, :text
  end
end
