class Category < ActiveRecord::Base
    belongs_to :user

    scope :of, -> (user){where(user_id: user.id)}
    scope :debits_first, -> {order(category_type: :desc, group: :asc, description: :asc)}

    def full_description
        group = !self[:group].empty? ? "#{self[:group]}/" : "" 
        "#{group}#{self[:description]}"
    end
end
