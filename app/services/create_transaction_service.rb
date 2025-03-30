require "net/http"
require "bitcoin"
require "dry/monads/result"
require "dry/monads/do"

class CreateTransactionService < ApplicationService
  include Dry::Monads::Result::Mixin
  include Dry::Monads::Do.for(:call)

  attr_reader :sender_address, :recipient_address, :amount

  MULTI = 100_000_000

  def initialize(sender_address, recipient_address, amount)
    @sender_address = sender_address
    @recipient_address = recipient_address
    @amount = amount * MULTI

    # Настройка сети
    Bitcoin.chain_params = :signet
  end

  def call
    utxos = yield get_utxos
    transaction = yield build_transaction(utxos)
    result = yield broadcast_transaction(transaction)

    Success(result)
  end

  def get_utxos
    url = "https://explorer.bc-2.jp/api/address/#{sender_address}/utxo"
    response = Net::HTTP.get(URI(url))
    utxos = JSON.parse(response).sort_by { |el| el["value"] }

    if utxos.any?
      Success(utxos)
    else
      Failure([ :no_utxos, "No UTXOs found for address #{sender_address}" ])
    end
  rescue => e
    Failure([ :api_error, "Failed to fetch UTXOs: #{e.message}" ])
  end

  def build_transaction(utxos)
    miner_fee = Settings.miner_fee * MULTI

    tx = Bitcoin::Tx.new
    tx.version = 2

    # Выбираем UTXO, пока не наберем нужную сумму
    selected_utxos = []
    total = 0
    utxos.each do |utxo|
      break if total >= amount + (miner_fee * (selected_utxos.size + 1))
      selected_utxos << utxo
      total += utxo["value"].to_i
    end

    if total < amount
      return Failure([ :small_balance, "Not enough funds. Need: #{amount}, Available: #{total}" ])
    end

    fee = miner_fee * selected_utxos.size
    change_amount = total - amount - fee

    # p "====selected_utxos:#{selected_utxos}==============="
    # p "====selected_utxos.size:#{selected_utxos.size}==============="
    # p "====miner_fee:#{miner_fee}==============="
    # p "====fee:#{fee}==============="
    # p "====change_amount:#{change_amount}==============="
    # p "====total:#{total}==============="

    if change_amount < 0
      return Failure([ :small_balance_with_fee, "Insufficient funds including commission. Need: #{amount}, Available: #{total}" ])
    end


    # Добавляем входы (выбранные UTXO)
    selected_utxos.each do |utxo|
      tx.in << Bitcoin::TxIn.new(out_point: Bitcoin::OutPoint.from_txid(utxo["txid"], utxo["vout"]))
    end

    # Добавляем выход получателю
    tx.out << Bitcoin::TxOut.new(
      value: amount,
      script_pubkey: Bitcoin::Script.parse_from_addr(recipient_address)
    )

    # Добавляем выход со сдачей (если есть)
    if change_amount > 0
      tx.out << Bitcoin::TxOut.new(
        value: change_amount,
        script_pubkey: Bitcoin::Script.parse_from_addr(sender_address)
      )
    end

    # Подписываем каждый вход
    key = Bitcoin::Key.from_wif(Settings.private_key_wif)

    selected_utxos.each_with_index do |utxo, input_index|
      # Для P2WPKH, script_code - это P2PKH scriptPubKey
      script_code = Bitcoin::Script.to_p2pkh(key.hash160)

      # Вычисляем хэш для подписи
      sighash = tx.sighash_for_input(input_index, script_code, sig_version: :witness_v0, amount: utxo["value"])

      # Создаем подпись
      signature = key.sign(sighash) + [ Bitcoin::SIGHASH_TYPE[:all] ].pack("C")

      # Собираем witness данные
      tx.in[input_index].script_witness.stack << signature
      tx.in[input_index].script_witness.stack << key.pubkey.htb

      # Проверяем подпись
      script_pubkey = Bitcoin::Script.parse_from_addr(sender_address)
      valid = tx.verify_input_sig(input_index, script_pubkey, amount: utxo["value"])
      # puts "Подпись для входа #{input_index} #{valid ? 'валидна' : 'невалидна'}"
    end

    Success(tx)
  end

  def broadcast_transaction(tx)
    begin
      uri = URI("https://mempool.space/signet/api/tx")

      req = Net::HTTP::Post.new(uri, "Content-Type" => "text/plain")
      # req.body = 'tx.to_payload.bth'
      req.body = tx.to_payload.bth

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
      if res.is_a?(Net::HTTPSuccess)
        Success(res.body)
      else
        Failure([ :api_tx_error, "Failed to push tx: #{res.body}" ])
      end
    rescue => e
      Failure([ :api_net_error, "Failed to push tx: #{e.message}" ])
    end
  end
end
