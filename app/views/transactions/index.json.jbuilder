json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :date, :amount, :category_id, :payee
  json.url transaction_url(transaction, format: :json)
end
