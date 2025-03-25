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
