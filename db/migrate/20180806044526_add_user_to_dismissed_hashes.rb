class AddUserToDismissedHashes < ActiveRecord::Migration[5.2]
  def change
    add_reference :dismissed_hashes, :user, index: true, foreign_key: true, type: :integer
  end
end
