require 'digest'

class HashService

  def self.compute_missing_hash(transaction)
    hash_input = "#{transaction.date}-#{transaction.category.full_description}-#{transaction.category.category_type}"
    Digest::SHA256.hexdigest hash_input
  end

end
