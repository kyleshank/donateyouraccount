FactoryGirl.define do
  factory :twitter_account do
    uid "123"
    name "testName"
    screen_name "testTwitter"
    token "testToken"
    secret "testSecret"
    followers 0
  end
end