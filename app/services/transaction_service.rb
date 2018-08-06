class TransactionService

  def self.dismiss(hash, user)
    dismissed = DismissedHash.new
    dismissed.user = user
    dismissed.missing_hash = hash
    dismissed.save
  end

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
    dates = get_dates_to_filter(frequency)
    dates_to_iterate = dates

    if frequency == :monthly
      dates_to_iterate = [Date.today]
    elsif frequency == :weekly
      dates_to_iterate = [dates.first]
    end

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
    
    existing_transactions = Transaction.where(user_id: user.id, date: dates.first..dates.last)
    existing_transactions_hashes = existing_transactions.map{|t| t.missing_hash}

    frequency_transactions_to_create = frequency_transactions_to_check.reject{|t| existing_transactions_hashes.include?(t.missing_hash)}

    dismissed_hashes = DismissedHash.where(user_id: user.id).to_a.map(&:missing_hash)
    frequency_transactions_to_create = frequency_transactions_to_create.reject{|t| dismissed_hashes.include?(t.missing_hash)}

    frequency_transactions_to_create
  end

  def self.get_dates_to_filter(frequency)
    today = Date.today
    dates = []

    if frequency == :daily
      dates = (Date.today.beginning_of_month..Date.today).to_a # all days until today
    elsif frequency == :weekly
      days_of_month = (today.beginning_of_month..today).to_a
      dates = days_of_month.select{|d| d.wday == days_of_month.first.wday} # all days in the same week day as the start of month, until today
      dates = dates.map{|d| [d, d + 6.days]}.first{|d| d >= today}.flatten # first pair start/end of week which contains the current date
    else
      dates = [today.beginning_of_month, today.end_of_month] #all days from the beginning up to the end of month
    end

    dates

  end

end
