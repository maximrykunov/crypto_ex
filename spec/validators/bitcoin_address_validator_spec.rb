require "rails_helper"

# class DummyModel
#   include ActiveModel::Model
#   attr_accessor :bitcoin_address

#   validates :bitcoin_address, bitcoin_address: true
# end

RSpec.describe BitcoinAddressValidator do
  subject { build(:order) }

  context "with valid addresses" do
    it "accepts valid Bech32 (tb1) address" do
      subject.quote_address = "tb1qey745jr5nuw64kwymxmsmeqqg36q7skpckrczm"
      expect(subject).to be_valid
    end
  end

  context "with invalid addresses" do
    it "rejects an empty address" do
      subject.quote_address = ""
      expect(subject).not_to be_valid
      expect(subject.errors[:quote_address]).to include("is not a valid Bitcoin address")
    end

    it "rejects an invalid Bech32 address" do
      subject.quote_address = "bc1invalidaddressxyz"
      expect(subject).not_to be_valid
    end
  end
end
