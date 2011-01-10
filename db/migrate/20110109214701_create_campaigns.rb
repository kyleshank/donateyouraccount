class CreateCampaigns < ActiveRecord::Migration
  def self.up
    Donation.delete_all
    create_table :campaigns do |t|
      t.references :account
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
