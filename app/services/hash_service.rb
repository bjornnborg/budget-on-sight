require 'digest'

class HashService

  def self.compute_missing_hash(transaction)
    return if transaction.category.oftenly?

    date_piece = transaction.date
    if transaction.category.monthly?
      date_piece = "#{transaction.date.at_beginning_of_month}-#{transaction.date.at_end_of_month}"
    elsif transaction.category.weekly?
      date_piece = "#{transaction.date.beginning_of_week(:sunday)}-#{transaction.date.end_of_week(:saturday)}"
    elsif transaction.category.daily?
      date_piece = "#{transaction.date}"
    end
    hash_input = "#{date_piece}-#{transaction.category.full_description}-#{transaction.category.category_type}"

    puts "hash input: #{hash_input}"
    Digest::SHA256.hexdigest hash_input
  end

end
