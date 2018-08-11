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
    #[:weekly].each do |frequency|
      result[frequency] = get_missing_transactions(user, frequency)
    end

    result
  end

  private

  def self.get_missing_transactions(user, frequency)
    dates = get_dates_to_filter(frequency)
    dates_to_iterate = dates

    if frequency == :monthly
      dates_to_iterate = [[Date.today, Date.today]]
    elsif frequency == :weekly
      #dates_to_iterate = [dates.first]
    end

    dates_to_iterate = dates.map{|d| d.first}

    frequency_categories = Category.where(user_id: user.id, frequency: frequency).debits_first.to_a
    frequency_transactions_to_check = []
    dates_to_iterate.each do |candidate_date|
      frequency_transactions_to_check << frequency_categories.map do |c|
        transaction = Transaction.new
        transaction.date = candidate_date
        transaction.category = c
        puts ">>>>>>>>HASH PARA A DATA #{candidate_date}"
        transaction.missing_hash = HashService.compute_missing_hash(transaction)        
        puts ">>>>>>>>#{transaction.missing_hash}"
        puts "------------------------"
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
  def self.get_dates_to_filter(frequency)
    today = Date.today
    dates = []

    if frequency == :daily
      dates = (Date.today.beginning_of_month..Date.today).to_a # all days until today
      dates = dates.map{|e| [e, e]}
    elsif frequency == :weekly
      days_of_month = (today.beginning_of_month..today).to_a
      dates = days_of_month.select{|d| d.wday == days_of_month.first.wday} # all days in the same week day as the start of month, until today
      puts "Dates are >>>>>>>>>>>>>>>>>>>>>>>>>"
      puts "#{dates}"      
      #dates = dates.map{|d| [d, d + 6.days]}.first{|d| d >= today}.flatten # first pair start/end of week which contains the current date
      dates = dates.map{|d| [d, d + 6.days]} # first pair start/end of week which contains the current date
      puts "Dates pairs are >>>>>>>>>>>>>>>>>>>>>>>>>"
      puts "#{dates}"
    else
      dates = [[today.beginning_of_month, today.end_of_month]] #all days from the beginning up to the end of month
    end

    dates

  end

end
