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

  def self.dates_to_filter(reference_date)
    end_date = reference_date.end_of_month

    on_this_month = Date.today.month == reference_date.month && Date.today.year == reference_date.year
    if (on_this_month)
      end_date = Date.today
    end

    dates = (reference_date.beginning_of_month..end_date).to_a # all days until today or the end of some month
    dates = dates.select{|d| d.wday == dates.first.wday} # all days in the same week day as the start of month, until today
    dates = dates.map{|d| [d, d + 6.days]} # pair of start/end of week
    dates.last[1] = end_date # ensure that we will not send a date from august if july ends
    dates
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
