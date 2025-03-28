# == Schema Information
#
# Table name: transactions
#
#  id            :bigint           not null, primary key
#  confirmations :integer          default(0)
#  retries       :integer          default(0)
#  txid          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_id      :bigint           not null
#
# Indexes
#
#  index_transactions_on_order_id  (order_id)
#  index_transactions_on_txid      (txid)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
