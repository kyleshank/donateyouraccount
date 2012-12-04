FactoryGirl.define do
  factory :donation do
  	level Donation::LEVELS["Silver"]
  end
end