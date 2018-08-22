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

end
