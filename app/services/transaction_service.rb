class TransactionService

  def self.dismiss(hash, user)
    dismissed = DismissedHash.new
    dismissed.user = user
    dismissed.missing_hash = hash
    dismissed.save
  end

  def self.save(transaction)
    ok = true
    installment_plan = transaction.get_installment_plan
    root = nil
    installment_plan.each do |t|
      # wrap saves/loop in transaction
      t.installment_transaction = root unless root.nil?
      ok = ok && t.save
      root ||= t

      break unless ok
    end
    ok
  end

  def self.destroy(transaction)
    transaction.destroy
  end

  def self.compute_missing_transactions(user)
    self.compute_missing_transactions_for_date(user, Date.today..Date.today)
  end

  def self.compute_missing_transactions_for_date(user, date_range)
    result = {}

    [:daily, :weekly, :monthly].each do |frequency|
    #[:daily].each do |frequency|
      result[frequency] = get_missing_transactions(user, frequency, date_range)
    end

    result
  end

  private

  def self.get_missing_transactions(user, frequency, date_range)
    dates = get_dates_to_filter(frequency, date_range)
    dates_to_iterate = dates

    if frequency == :monthly
      if (date_range.include?(Date.today))
        dates_to_iterate = [[Date.today, Date.today]]
      else
        dates_to_iterate = [[date_range.first, date_range.last]]
      end
    elsif frequency == :weekly
      #dates_to_iterate = [dates.first]
    end

    dates_to_iterate = dates_to_iterate.map{|d| d.first}

    frequency_categories = Category.where(user_id: user.id, frequency: frequency).debits_first.to_a
    frequency_transactions_to_check = []
    dates_to_iterate.each do |candidate_date|
      frequency_transactions_to_check << frequency_categories.map do |c|
        transaction = Transaction.new
        transaction.date = candidate_date
        transaction.category = c
        transaction.missing_hash = HashService.compute_missing_hash(transaction)        
        transaction
      end
    end

    frequency_transactions_to_check.flatten!

    frequency_hashes = frequency_transactions_to_check.map{|t| t.missing_hash}
    
    existing_transactions = Transaction.where(user_id: user.id, date: dates.first.first..dates.last.last)
    existing_transactions_hashes = existing_transactions.map{|t| t.missing_hash}

    frequency_transactions_to_create = frequency_transactions_to_check.reject{|t| existing_transactions_hashes.include?(t.missing_hash)}

    dismissed_hashes = DismissedHash.where(user_id: user.id).to_a.map(&:missing_hash)
    frequency_transactions_to_create = frequency_transactions_to_create.reject{|t| dismissed_hashes.include?(t.missing_hash)}

    frequency_transactions_to_create
  end

  #array of arrays with begin/end dates
  def self.get_dates_to_filter(frequency, date_range)
    dates = []

    if frequency == :daily
      dates = Range::SuggestionDailyRange.dates_to_filter(date_range.last)
    elsif frequency == :weekly
      dates = Range::SuggestionWeeklyRange.dates_to_filter(date_range.last)
    elsif frequency == :monthly
      dates = Range::SuggestionMonthlyRange.dates_to_filter(date_range.last)
    end

    dates
  end

end
