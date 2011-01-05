class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.references :account
      t.references :campaign
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :donations
  end
end
