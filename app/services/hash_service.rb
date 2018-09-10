require 'digest'

class HashService

  def self.compute_missing_hash(transaction)
    return if transaction.category.oftenly?

    suggestion_range = nil

    if transaction.category.monthly?
      suggestion_range = Range::SuggestionMonthlyRange.new(transaction)
    elsif transaction.category.weekly?
      suggestion_range = Range::SuggestionWeeklyRange.new(transaction)
    else
      suggestion_range = Range::SuggestionDailyRange.new(transaction)
    end

    Digest::SHA256.hexdigest suggestion_range.suggestion_string
  end

end
