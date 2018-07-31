class TransactionService

  def self.compute_missing_transactions(user)
    self.compute_missing_transactions_for_date(user, Date.today)
  end

  def self.compute_missing_transactions_for_date(user, date)
    result = {}
    start_of_month = date.at_beginning_of_month
    end_of_month = date.at_end_of_month

    monthly_categories = Category.where(user_id: user.id, frequency: :monthly).debits_first.to_a
    monthly_transactions_to_check = monthly_categories.map do |c|
      transaction = Transaction.new
      transaction.date = Date.today
      transaction.category = c
      transaction.missing_hash = HashService.compute_missing_hash(transaction)
      transaction
    end

    monthly_hashes = monthly_transactions_to_check.map{|t| t.missing_hash}
    existing_transactions = Transaction.where(user_id: user.id).where.not(missing_hash: monthly_hashes)
    existing_transactions_hashes = existing_transactions.map{|t| t.missing_hash}

    monthly_transactions_to_create = monthly_transactions_to_check.reject{|t| existing_transactions_hashes.include?(t.missing_hash)}    
    result[:monthly] = monthly_transactions_to_create


    weekly_categories = Category.where(user_id: user.id, frequency: :weekly).debits_first.to_a
    weekly_transactions_to_check = weekly_categories.map do |c|
      transaction = Transaction.new
      transaction.date = Date.today
      transaction.category = c
      transaction.missing_hash = HashService.compute_missing_hash(transaction)
      transaction
    end

    weekly_hashes = weekly_transactions_to_check.map{|t| t.missing_hash}
    existing_transactions = Transaction.where(user_id: user.id).where.not(missing_hash: weekly_hashes)
    existing_transactions_hashes = existing_transactions.map{|t| t.missing_hash}

    weekly_transactions_to_create = weekly_transactions_to_check.reject{|t| existing_transactions_hashes.include?(t.missing_hash)}    
    result[:weekly] = weekly_transactions_to_create

    daily_categories = Category.where(user_id: user.id, frequency: :daily).debits_first.to_a
    daily_transactions_to_check = daily_categories.map do |c|
      transaction = Transaction.new
      transaction.date = Date.today
      transaction.category = c
      transaction.missing_hash = HashService.compute_missing_hash(transaction)
      transaction
    end

    daily_hashes = daily_transactions_to_check.map{|t| t.missing_hash}
    existing_transactions = Transaction.where(user_id: user.id).where.not(missing_hash: daily_hashes)
    existing_transactions_hashes = existing_transactions.map{|t| t.missing_hash}

    daily_transactions_to_create = daily_transactions_to_check.reject{|t| existing_transactions_hashes.include?(t.missing_hash)}    
    result[:daily] = daily_transactions_to_create    


    result

  end  

end
