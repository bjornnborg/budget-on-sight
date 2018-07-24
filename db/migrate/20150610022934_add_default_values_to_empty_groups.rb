class AddDefaultValuesToEmptyGroups < ActiveRecord::Migration[5.0]
  def change
    say_with_time "Setting default value for empty groups..." do
      Category.where(group: "").find_each do |category|
        category.update_attribute :group, 'Default'
      end
    end
  end
end
