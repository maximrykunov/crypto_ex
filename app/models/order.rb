class Order < ApplicationRecord
  BASE_CURRENCIES = %w[USDT].freeze
  QUOTE_CURRENCIES = %w[SBTC].freeze

  belongs_to :user
  # has_many :transactions, dependent: :nullify

  enum :order_type, [ :limit ], prefix: true
  enum :order_side, [ :exchange ]
  enum :status, [ :pending, :completed, :cancelled ]

  validates :user, presence: true
  validates :order_type, presence: true
  validates :order_side, presence: true
  validates :base_currency, presence: true, inclusion: { in: BASE_CURRENCIES }
  validates :base_address, presence: true
  validates :quote_currency, presence: true, inclusion: { in: QUOTE_CURRENCIES }
  validates :quote_address, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }, if: -> { order_type_limit? }

  def total
    amount * price
  end
end
