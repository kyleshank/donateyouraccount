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
module RetryHelper
  def try_to(&block)
    retries = 0
    e = nil
    while retries < 5
      begin
        response = yield
        return response
      rescue Exception => ex
        retries += 1
        e = ex
        sleep(1)
      end
    end
    raise RetryException.new("Retry failure: #{e.class} <#{e.message}>")
  end
end

class RetryException < Exception
end