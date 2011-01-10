class RenameAccountReferenceStatus < ActiveRecord::Migration
  def self.up
    Status.delete_all
    rename_column :statuses, :account_id, :campaign_id
  end

  def self.down
    rename_column :statuses, :campaign_id, :account_id
  end
end
