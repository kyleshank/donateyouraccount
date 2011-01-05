class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.references :account
      t.string :body
      t.string :twitter_status_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :statuses
  end
end
