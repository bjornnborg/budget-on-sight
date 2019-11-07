module DateHelper

  def date_range(hint_params = nil)
    return Time.zone.now.at_beginning_of_month..Time.zone.now.at_end_of_month if hint_params.nil? || no_params_supplied(hint_params)
    reference = Time.now
    year = reference.strftime("%Y").to_i
    month = reference.strftime("%m").to_i
    day = reference.strftime("%d").to_i

    year =  hint_params[:year].to_i if hint_params[:year]
    initial_date = Date.new(year) if year && hint_params[:month].nil? && hint_params[:day].nil?
    final_date = initial_date.at_end_of_year if initial_date
    return initial_date..final_date if initial_date and final_date

    month = hint_params[:month].to_i if hint_params[:month]
    initial_date = Date.new(year, month) if month && hint_params[:day].nil?
    final_date = initial_date.at_end_of_month if initial_date
    return initial_date..final_date if initial_date and final_date

    day = hint_params[:day].to_i if hint_params[:day]
    initial_date = Date.new(year, month, day)
    final_date = initial_date.at_end_of_day if initial_date
    return initial_date..final_date if initial_date and final_date

  end

  def previous_date_range(date_range)
    previous = Range.new(0, 0)
    if (date_range.first.strftime("%Y%m%d") == date_range.last.strftime("%Y%m%d"))
      day = date_range.first.at_beginning_of_day - 1.days
      previous = (day..day.at_end_of_day)
    elsif (date_range.first.strftime("%Y%m") == date_range.last.strftime("%Y%m"))
      day = date_range.first.at_beginning_of_month - 1.months
      previous = (day..day.at_end_of_month)
    elsif (date_range.first.strftime("%Y") == date_range.last.strftime("%Y"))
      day = date_range.first.at_beginning_of_year - 1.years
      previous = (day..day.at_end_of_year)
    end

    previous

  end

  private

  def no_params_supplied(hint_params)
    hint_params.keys.select {|k| k.to_sym == :year || k.to_sym == :month || k.to_sym == :day}.size == 0
  end

end
