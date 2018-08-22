class Range::SuggestionWeeklyRange

  def initialize(transaction)
    @transaction = transaction
  end

  def date_piece
    days_of_month = all_dates_until(@transaction.date)
    dates = days_in_same_weekday_of_start_of_month(days_of_month)
    dates = week_date_ranges(dates)
    dates = any_date_range_which_covers(dates)
    date_piece = "#{dates.first}-#{dates.last}"
    date_piece
  end

  def suggestion_string
    "#{self.date_piece}-category:#{@transaction.category.id}"
  end

  private

  def all_dates_until(date)
    (@transaction.date.beginning_of_month..date).to_a
  end

  def days_in_same_weekday_of_start_of_month(dates)
    dates.select{|d| d.wday == dates.first.wday} # all days in the same week day as the start of month, until today. Eg. All wednesdays
  end

  def week_date_ranges(dates)
    dates.map{|d| (d..(d + 6.days))} #date from wednesday until next tuesday
  end

  def any_date_range_which_covers(dates)
    dates.detect{|d| d.cover?(@transaction.date)}
  end

end
