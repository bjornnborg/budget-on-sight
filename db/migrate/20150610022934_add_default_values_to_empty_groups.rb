class AddDefaultValuesToEmptyGroups < ActiveRecord::Migration
  def change
    say_with_time "Setting default value for empty groups..." do
        Category.where(group: :nil).each do |category|
            category.update_attribute :group, 'Default'
        end
    end
  end
end
