FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :with_admin do
      admin_role { true }
    end
  end
end
