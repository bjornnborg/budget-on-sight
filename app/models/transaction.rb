class Transaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  scope :newer_first, -> {order(date: :desc, created_at: :asc)}
  scope :oldest_first, -> {order(date: :asc, created_at: :asc)}
  default_scope -> {joins(:category)}

  validates_presence_of :date, :amount, :category_id

  def debit?
    !credit?
  end

  def credit?
    self.category.credit? if self.category
  end

  def amount
    if self[:amount]
      shift_needed = (self[:amount] > 0 && debit?) || (self[:amount] < 0 && credit?)
      self[:amount] *= -1 if shift_needed
    end
    self[:amount]
  end
end
