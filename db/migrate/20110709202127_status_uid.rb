class StatusUid < ActiveRecord::Migration
  def self.up
    rename_column :statuses, :twitter_status_id, :uid
  end

  def self.down
    rename_column :statuses, :uid, :twitter_status_id
  end
end
