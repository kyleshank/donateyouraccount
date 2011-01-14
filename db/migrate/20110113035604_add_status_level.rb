class AddStatusLevel < ActiveRecord::Migration
  def self.up
    add_column :statuses, :level, :integer
  end

  def self.down
    remove_column :statuses, :level
  end
end
