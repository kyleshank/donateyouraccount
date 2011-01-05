class AddTwitterFields < ActiveRecord::Migration
  def self.up
    add_column :accounts, :url, :string
    add_column :accounts, :description, :string
    add_column :accounts, :location, :string
    add_column :accounts, :profile_sidebar_border_color, :string
    add_column :accounts, :profile_sidebar_fill_color, :string
    add_column :accounts, :profile_link_color, :string
    add_column :accounts, :profile_image_url, :string
    add_column :accounts, :profile_background_color, :string
    add_column :accounts, :profile_background_image_url, :string
    add_column :accounts, :profile_text_color, :string
    add_column :accounts, :profile_background_tile, :boolean
    add_column :accounts, :profile_use_background_image, :boolean
  end

  def self.down
    remove_column :accounts, :url
    remove_column :accounts, :description
    remove_column :accounts, :location
    remove_column :accounts, :profile_sidebar_border_color
    remove_column :accounts, :profile_sidebar_fill_color
    remove_column :accounts, :profile_link_color
    remove_column :accounts, :profile_image_url
    remove_column :accounts, :profile_background_color
    remove_column :accounts, :profile_background_image_url
    remove_column :accounts, :profile_text_color
    remove_column :accounts, :profile_background_tile
    remove_column :accounts, :profile_use_background_image
  end
end
