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
class Status < ActiveRecord::Base
  belongs_to :campaign
  has_many :donated_statuses
  has_many :donations, :through => :donated_statuses
  has_many :accounts, :through => :donations

  validates_presence_of :campaign, :uid

  scope :accounts, -> {joins("INNER JOIN donated_statuses ON donated_statuses.status_id = statuses.id INNER JOIN donations ON donations.id = donated_statuses.donation_id INNER JOIN accounts ON donations.account_id = accounts.id ")}
  scope :donated_through_account, ->(a) { accounts.where((a.is_a?(Array) ? a.collect{|c| "accounts.id=#{c.id}"}.join(" OR ") : ["accounts.id = ?", a.id]))}
  scope :desc, -> {order("statuses.id desc")}
  scope :within_1_day, -> { where("statuses.created_at > (NOW()-#{1.day.to_i})")}
  scope :within_1_week, -> { where("statuses.created_at > (NOW()-#{7.day.to_i})")}
  scope :within_1_month, -> { where("statuses.created_at > (NOW()-#{28.day.to_i})")}
  scope :for_levels, -> (levels) {where(levels.collect{|l| "statuses.level = #{l}"}.join(" OR "))}

  attr_accessor :levels

  after_create do
    self.delay.publish
  end

  def reach
    self.accounts.sum(:followers)
  end
end
