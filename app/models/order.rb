# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  base_address   :string           not null
#  base_currency  :string           not null
#  fee            :decimal(20, 8)   not null
#  message        :string
#  miner_fee      :decimal(20, 8)   not null
#  order_side     :integer          default("exchange"), not null
#  order_type     :integer          default("limit"), not null
#  price          :decimal(20, 8)   not null
#  quote_address  :string           not null
#  quote_currency :string           not null
#  receive_amount :decimal(20, 8)   not null
#  send_amount    :decimal(20, 8)   not null
#  status         :integer          default("pending"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Order < ApplicationRecord
  attr_accessor :i_agree_kyc

  belongs_to :user
  has_one :order_transaction, class_name: "Transaction", dependent: :destroy

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
