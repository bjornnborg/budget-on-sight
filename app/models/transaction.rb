class Transaction < ActiveRecord::Base
  before_validation :normalized_amount
  before_save :compute_missing_hash

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
    category.credit? if category
  end

  def normalized_amount
    if self[:amount]
      self[:amount] *= -1 if shift_needed
    end
    self[:amount]
  end

  private

  def compute_missing_hash
    self[:missing_hash] = HashService.compute_missing_hash(self)
  end

  def shift_needed
    (self[:amount] > 0 && debit?) || (self[:amount] < 0 && credit?)
  end
end
