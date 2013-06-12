FactoryGirl.define do

  factory :discipline do
    name "Informatik"
  end

  factory :user do
    uid "test@user.edu"
    name "Test User"
    disciplines {[FactoryGirl.create(:discipline)]}
  end



end