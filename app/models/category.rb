class Category < ActiveRecord::Base
    belongs_to :user

    #scope :of, -> (user){where(user_id: user.id)}
    scope :debits_first, -> {order(category_type: :desc, group: :asc, description: :asc)}

    validates_presence_of :description, :category_type, :frequency
    validate :only_debits_can_be_investment

    def only_debits_can_be_investment
        if credit?
            errors.add(:base, 'Only debits can be marked as an investment') unless debit?
        end
    end

    def full_description
        group = !self[:group].empty? ? "#{self[:group]}/" : "" 
        "#{group}#{self[:description]}"
    end

    def debit?
        self.category_type.to_sym == :debit
    end

    def credit?
        !debit?
    end
end
