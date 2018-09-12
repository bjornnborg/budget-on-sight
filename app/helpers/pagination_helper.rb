module PaginationHelper

  def previous_month_link(path)
    date = get_date
    prev_month_date = (date - 1.month)
    link_to 'Previous month', "#{path}?year=#{prev_month_date.strftime("%Y")}&month=#{prev_month_date.strftime("%m")}"
  end

  def next_month_link(path)
    date = get_date
    next_month_date = (date + 1.month)
    link_to 'Next month', "#{path}?year=#{next_month_date.strftime("%Y")}&month=#{next_month_date.strftime("%m")}"
  end

  def get_month_link(label, path)
    context_date = get_date
    link_to label, "#{path}?year=#{context_date.strftime("%Y")}&month=#{context_date.strftime("%m")}"
  end

  private

  def get_date
    month = params[:month] || Time.zone.now.strftime('%m')
    year = params[:year] || Time.zone.now.strftime('%Y')
    date = Time.zone.strptime("#{year}-#{month}-01", "%Y-%m-%d")
    date
  end

end
