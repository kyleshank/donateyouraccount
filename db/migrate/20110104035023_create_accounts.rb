class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :uid
      t.string :name
      t.string :screen_name
      t.string :token
      t.string :secret
      t.integer :followers
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
