class AddFacebookPagesToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :facebook_pages, :text
    add_column :campaigns, :facebook_page, :text
    remove_column :campaigns, :image
  end

  def self.down
    remove_column :accounts, :facebook_pages
    remove_column :campaigns, :facebook_page
    add_column :campaigns, :image, :string
  end
end
