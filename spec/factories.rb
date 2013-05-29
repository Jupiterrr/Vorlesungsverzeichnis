FactoryGirl.define do
  #sequence(:name) { |n| "node #{n}" }
  sequence(:external_id) { |n| "0x#{n}" }

  factory :vvz do
  end

  factory :event do |f|
    external_id
  end
end