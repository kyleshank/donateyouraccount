class TwitterFacebookStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :type, :string
    add_column :statuses, :data, :text
    Status.reset_column_information
    Status.update_all(:type=>"TwitterStatus")
  end

  def self.down
    remove_column :statuses, :type
    remove_column :statuses, :data
  end
end
