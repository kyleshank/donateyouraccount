class DonationLevelNames < ActiveRecord::Migration
  def change
  	add_column :campaigns, :level_gold, :string
  	add_column :campaigns, :level_silver, :string
  	add_column :campaigns, :level_bronze, :string
  end
end
