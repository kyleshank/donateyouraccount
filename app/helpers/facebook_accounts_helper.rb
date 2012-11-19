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
module FacebookAccountsHelper
  def get_oauth_client
    OAuth2::Client.new(FACEBOOK_APPLICATION_ID, FACEBOOK_APPLICATION_SECRET,
      :token_url => '/oauth/access_token',
                       :site => {
                         :url => 'https://graph.facebook.com',
                         :ssl => {
                           :verify => OpenSSL::SSL::VERIFY_PEER,
                           :ca_file => File.join(Rails.root, "lib", "cacert.pem")
                         }
                       })
  end
end