require 'digest'

class HashService

  def self.compute_missing_hash(transaction)
    return if transaction.category.oftenly?

    date_piece = transaction.date
    if transaction.category.monthly?
      date_piece = "#{transaction.date.at_beginning_of_month}-#{transaction.date.at_end_of_month}"
    elsif transaction.category.weekly?
      days_of_month = (transaction.date.beginning_of_month..Date.today).to_a
      dates = days_of_month.select{|d| d.wday == days_of_month.first.wday} # all days in the same week day as the start of month, until today
      #dates = dates.map{|d| [d, d + 6.days]}.first{|d| d.fisrt >= transaction.date}.flatten # first start/end of week which contains the current date
      dates = dates.map{|d| [d, d + 6.days]}
      puts "DATES TO HASH: #{dates}"
      dates = dates.detect{|d| d.first >= transaction.date}.flatten # first start/end of week which contains the current date
      date_piece = "#{dates.first}-#{dates.last}"
      puts "=====================date piece?"
      puts "=====================#{date_piece}"
    elsif transaction.category.daily?
      date_piece = "#{transaction.date}"
    end

    hash_input = "#{date_piece}-category:#{transaction.category.id}"
    Digest::SHA256.hexdigest hash_input
  end

end
