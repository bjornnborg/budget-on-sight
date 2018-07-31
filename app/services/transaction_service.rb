class TransactionService

  def self.compute_missing_transactions(user)
    self.compute_missing_transactions_for_date(user, Date.today)
  end

  def self.compute_missing_transactions_for_date(user, date)
    result = {}

    [:daily, :weekly, :monthly].each do |frequency|
      result[frequency] = get_missing_transactions(user, frequency)
    end

    result
  end

  private

  def self.get_missing_transactions(user, frequency)
    frequency_categories = Category.where(user_id: user.id, frequency: frequency).debits_first.to_a
    frequency_transactions_to_check = frequency_categories.map do |c|
      transaction = Transaction.new
      transaction.date = Date.today
      transaction.category = c
      transaction.missing_hash = HashService.compute_missing_hash(transaction)
      transaction
    end

    frequency_hashes = frequency_transactions_to_check.map{|t| t.missing_hash}
    dates = get_dates_to_filter(frequency)
    existing_transactions = Transaction.where(user_id: user.id, date: dates[0]..dates[1])
    existing_transactions_hashes = existing_transactions.map{|t| t.missing_hash}

    frequency_transactions_to_create = frequency_transactions_to_check.reject{|t| existing_transactions_hashes.include?(t.missing_hash)}    
    frequency_transactions_to_create
  end

  def self.get_dates_to_filter(frequency)
    date = Date.today
    dates = [date, date]

    if frequency == :weekly
      if date.sunday?
        dates = [date, date]
      else
        dates = [date.prev_occurring(:sunday), date.end_of_week(:sunday)]
      end
    else
      dates = [date.beginning_of_month, date.end_of_month]
    end
  end

end
