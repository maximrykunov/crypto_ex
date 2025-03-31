require "bech32"
require "bitcoin"

class BitcoinAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid_bech32?(value) || valid_base58?(value)

    record.errors.add(attribute, "is not a valid Bitcoin address")
  end

  private

  def valid_bech32?(address)
    hrp, _data, _spec = Bech32.decode(address)
    %w[bc tb].include?(hrp) # bc - mainnet, tb - testnet
  rescue StandardError
    false
  end

  def valid_base58?(address)
    Bitcoin.valid_address?(address)
  rescue StandardError
    false
  end
end
