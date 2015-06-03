class Category < ActiveRecord::Base
    belongs_to :user

    def full_description
        group = !self[:group].empty? ? "#{self[:group]}/" : "" 
        "#{group}#{self[:description]}"
    end
end
