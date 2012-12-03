FactoryGirl.define do
  factory :facebook_account do
    uid "213123"
    name "testName"
    screen_name "testFacebook"
    token "testToken"
    secret "testSecret"
    facebook_pages "{}"
    followers 0
  end
end