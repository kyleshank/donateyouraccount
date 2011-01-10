class AddDonationLevel < ActiveRecord::Migration
  def self.up
    add_column :donations, :level, :integer
  end

  def self.down
    remove_column :donations, :level
  end
end
