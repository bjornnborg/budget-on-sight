class Transaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  scope :of, -> (user){where(user_id: user.id)}
  scope :newer_first, -> {order(date: :desc, created_at: :asc)}
  scope :oldest_first, -> {order(date: :asc, created_at: :asc)}
end
