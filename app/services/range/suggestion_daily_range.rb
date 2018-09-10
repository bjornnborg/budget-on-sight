class Range::SuggestionDailyRange

  def initialize(transaction)
    @transaction = transaction
  end

  def date_piece
    "#{@transaction.date}"
  end

  def suggestion_string
    "#{self.date_piece}-category:#{@transaction.category.id}"
  end

  def self.dates_to_filter(reference_date)
    end_date = reference_date.end_of_month

    on_this_month = Date.today.month == reference_date.month && Date.today.year == reference_date.year
    if (on_this_month)
      end_date = Date.today
    end

    dates = (reference_date.beginning_of_month..end_date).to_a # all days until today or the end of some month
    dates = dates.map{|e| [e, e]}
  end

end
