FactoryGirl.define do

  factory :discipline do
    name "Informatik"
  end

  factory :user do
    uid "test@user.edu"
    name "Test User"
    disciplines {[FactoryGirl.create(:discipline)]}
  end

  factory :vvz do
    name "vvz-node"
  end

  factory :event do
    # nr
    name "Schwedisch 1"
    # lecturer
    # term
    # url
    # description
    # external_id
    # original_name
    user_text_md "..."
    vvzs {[FactoryGirl.create(:vvz)]}
  end

end
