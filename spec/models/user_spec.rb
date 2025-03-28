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
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Validation' do
    let(:user) { build(:user) }

    context 'Should validate' do
      it 'with email_address' do
        expect(user).to be_valid
      end
    end

    context 'Should not be valid' do
      it 'when email_address is not present' do
        user.email_address = nil
        expect(user).not_to be_valid
      end
    end
  end
end
