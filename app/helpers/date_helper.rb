module DateHelper

  def date_range(hint_params = nil)
    return Time.now.at_beginning_of_month..Time.now.at_end_of_month if hint_params.nil?
  end

end