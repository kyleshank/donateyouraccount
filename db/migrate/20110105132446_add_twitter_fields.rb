##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2011  Kyle Shank (kyle.shank@gmail.com)
# http://www.gnu.org/licenses/agpl.html
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##
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
