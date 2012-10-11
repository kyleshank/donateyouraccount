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
Dya::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end

Twitter.configure do |config|
  config.consumer_key = "zCCT5sif1Blu4DfRmSP9RA"
  config.consumer_secret = "oJFFXFx1tD3fY0ETSYeOpwV8zLGiuBSntxxgj8c"
end

TWITTER_CONSUMER_KEY="zCCT5sif1Blu4DfRmSP9RA"
TWITTER_CONSUMER_SECRET="oJFFXFx1tD3fY0ETSYeOpwV8zLGiuBSntxxgj8c"

FACEBOOK_OAUTH_REDIRECT = "http://dev.donateyouraccount.com/facebook_accounts/oauth_create"
FACEBOOK_APPLICATION_ID="145481695503129"
FACEBOOK_APPLICATION_SECRET="53445c024a5f5a8a638e4542bdd49a37"