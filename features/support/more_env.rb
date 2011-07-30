require 'rspec/rails'

require 'capybara/cucumber'
require 'capybara/rails'

Capybara.default_driver = :selenium
Cucumber::Rails::World.use_transactional_fixtures = false

class FakeNetHTTPResponse < Net::HTTPSuccess
  def initialize(*args)
  end
  def body
    '{"is_translator":false,"verified":false,"profile_background_color":"404040","lang":"en","profile_background_image_url":"http:\/\/a0.twimg.com\/profile_background_images\/174082691\/logo.png","created_at":"Fri Nov 07 17:35:57 +0000 2008","description":"building things.","screen_name":"kyleshank","status":{"in_reply_to_user_id_str":"25037666","text":"@greggiacovelli oh god greg! stackoverflow is like the SE lab.","coordinates":null,"retweeted":false,"retweet_count":0,"created_at":"Mon Jan 17 19:44:03 +0000 2011","in_reply_to_user_id":25037666,"place":null,"source":"\u003Ca href=\"http:\/\/itunes.apple.com\/us\/app\/twitter\/id409789998?mt=12\" rel=\"nofollow\"\u003ETwitter for Mac\u003C\/a\u003E","in_reply_to_status_id":27088609634947072,"truncated":false,"favorited":false,"in_reply_to_status_id_str":"27088609634947072","id_str":"27088783446908928","geo":null,"id":27088783446908928,"contributors":null,"in_reply_to_screen_name":"greggiacovelli"},"show_all_inline_media":true,"geo_enabled":true,"friends_count":168,"url":"http:\/\/kyleshank.com","follow_request_sent":false,"profile_text_color":"333333","followers_count":180,"following":false,"favourites_count":0,"profile_sidebar_fill_color":"5c5c5c","location":"United States of America","profile_background_tile":false,"time_zone":"Eastern Time (US & Canada)","listed_count":9,"statuses_count":1641,"profile_link_color":"f89924","protected":false,"profile_sidebar_border_color":"474747","name":"Kyle Shank","id_str":"17234882","contributors_enabled":false,"id":17234882,"notifications":false,"profile_use_background_image":true,"utc_offset":-18000,"profile_image_url":"http:\/\/a2.twimg.com\/profile_images\/799270743\/profile_photo_cropped_normal.png"}'
  end
end

class FakeRequestToken < OAuth::RequestToken
  def initialize(*args)
  end
  def get_access_token(arg1)
    FakeAccessToken.new
  end
end

class FakeAccessToken < OAuth::AccessToken
  def initialize(*args)
  end
  def token
    "test_token"
  end
  def secret
    "test_secret"
  end
end

class FakeConsumer < OAuth::Consumer
  def initialize(*args)
  end

  def request(*args)
    FakeNetHTTPResponse.new
  end
end

class FacebookAccessToken < OAuth2::AccessToken
  def initialize(*args)

  end
  def get(*args)
    case args.first
      when "/me"
        '{"id":"1480286883","name":"Kyle Shank","first_name":"Kyle","last_name":"Shank","link":"http:\/\/www.facebook.com\/kyleshank","location":{"id":"","name":null},"gender":"male","timezone":-5,"locale":"en_US","verified":true,"updated_time":"2010-08-11T14:25:24+0000"}'
      when "/me/accounts"
        '{"data":[{"name":"Donate Your Account","category":"Website","id":"128107323942962"},{"name":"Reactualize","category":"Product/service","id":"104955406227901"},{"name":"Donate Your Account","category":"Application","id":"114902775246811"},{"name":"Donate Your Account Staging","category":"Application","id":"145481695503129"},{"category":"Application","id":"143681932313719"},{"category":"Application","id":"121454094533824"},{"category":"Application","id":"112835425422620"},{"category":"Application","id":"178035084190"}]}'
    end
  end
end

class FacebookOauthClient < OAuth2::Client
  def initialize(*args)
  end
  def web_server
    self
  end
  def get_access_token(*args)
    FacebookAccessToken.new
  end
end