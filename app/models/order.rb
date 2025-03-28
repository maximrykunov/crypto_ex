class Order < ApplicationRecord
  attr_accessor :i_agree_kyc

  belongs_to :user

  enum :order_type, [ :limit ], prefix: true
  enum :order_side, [ :exchange ]
  enum :status, [ :pending, :completed, :cancelled ]

  validates :user, presence: true
  validates :order_type, presence: true
  validates :order_side, presence: true
  validates :base_currency, presence: true, inclusion: { in: Settings.base_currencies }
  validates :base_address, presence: true
  validates :quote_currency, presence: true, inclusion: { in: Settings.quote_currencies }
  validates :quote_address, presence: true
  validates :send_amount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 30  }
  validates :price, presence: true, numericality: { greater_than: 0 }, if: -> { order_type_limit? }
  validates :receive_amount, presence: true, numericality: { greater_than: 0 }
  validates :i_agree_kyc, acceptance: { accept: "true", message: "You must agree to the terms" }

  validate :valid_quote_address

  private

  def valid_quote_address
    if quote_address.present? && !quote_address.match?(/\A([13][a-km-zA-HJ-NP-Z0-9]{26,33}|bc1[a-zA-HJ-NP-Z0-9]{11,71})\z/)
      errors.add(:quote_address, "is not a valid address")
    end
  end
end
