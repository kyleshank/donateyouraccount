class CreateDonatedStatuses < ActiveRecord::Migration
  def self.up
    create_table :donated_statuses do |t|
      t.references :donation
      t.references :status
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :donated_statuses
  end
end
