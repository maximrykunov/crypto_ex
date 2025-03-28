# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin_role      :boolean          default(FALSE), not null
#  email_address   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
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
