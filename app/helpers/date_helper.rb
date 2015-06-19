module DateHelper

  def date_range(hint_params = nil)
    return Time.now.at_beginning_of_month..Time.now.at_end_of_month if hint_params.nil?
    reference = Time.now
    year = reference.strftime("%Y")
    month = reference.strftime("%m")
    month = reference.strftime("%d")

    year =  hint_params[:year] if hint_params[:year]
    initial_date = Date.new(year) if year && hint_params[:month].nil?
    final_date = initial_date.at_end_of_year if initial_date
    return initial_date..final_date if initial_date and final_date

    month = hint_params[:month] if hint_params[:month]
    initial_date = Date.new(year, month) if month && hint_params[:day].nil?
    final_date = initial_date.at_end_of_month if initial_date
    return initial_date..final_date if initial_date and final_date

    day = hint_params[:day] if hint_params[:day]
    initial_date = Date.new(year, month, day)
    final_date = initial_date.at_end_of_day if initial_date
    return initial_date..final_date if initial_date and final_date    

  end

end