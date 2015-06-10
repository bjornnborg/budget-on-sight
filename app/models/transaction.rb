class Transaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  #scope :of, -> (user){where(user_id: user.id)}
  scope :newer_first, -> {order(date: :desc, created_at: :asc)}
  scope :oldest_first, -> {order(date: :asc, created_at: :asc)}

  validates_presence_of :date, :amount, :category_id

  def debit?
    !credit?
  end

  def credit?
    self.category.credit? if self.category
  end

  def amount
    if self[:amount]
      if self[:amount] > 0
          self[:amount] *= -1 unless credit?
      elsif self[:amount] < 0 
          self[:amount] *= -1 unless debit?
      end
    end
    self[:amount]
  end
end
