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

end
