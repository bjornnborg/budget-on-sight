class Range::SuggestionMonthlyRange

  def initialize(transaction)
    @transaction = transaction
  end

  def date_piece
    "#{@transaction.date.at_beginning_of_month}-#{@transaction.date.at_end_of_month}"
  end

  def suggestion_string
    "#{self.date_piece}-category:#{@transaction.category.id}"
  end

  def self.dates_to_filter(reference_date)
    [[reference_date.beginning_of_month, reference_date.end_of_month]]
  end

end
