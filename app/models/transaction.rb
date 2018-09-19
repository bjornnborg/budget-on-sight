class Transaction < ActiveRecord::Base
  before_validation :normalized_amount
  before_save :compute_missing_hash

  belongs_to :category
  belongs_to :user

  belongs_to :installment_transaction, class_name: "Transaction", foreign_key: :id
  has_many :installment_transactions, class_name: "Transaction", foreign_key: :installment_transaction_id

  scope :newer_first, -> {order(date: :desc, created_at: :asc)}
  scope :oldest_first, -> {order(date: :asc, created_at: :asc)}
  scope :from_group, -> (group_name) {Transaction.merge(Category.from_group(group_name))}
  default_scope -> {eager_load(:category)}

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

  def fmt_payee
    "#{self.payee} (#{self.installment_number}/#{self.installments})".strip
  end

  def /(installments)
    installments ||= 1
    self.amount ||= 0.0
    transactions = []
    last_date = self.date || Time.now

    (1..installments).each do |installment|
      transaction = Transaction.new(category: self.category, payee: self.payee, user: self.user)
      transactions << transaction

      transaction.amount = self.amount / installments
      transaction.date = last_date
      transaction.payee = self.payee
      transaction.installments = installments
      transaction.installment_number = installment      
      transaction.installment_transaction = transactions.first
      last_date = resolve_installment_date(last_date)
    end
    transactions
  end

  private

  def resolve_installment_date(last_date)
    intended_date = last_date + 1.month
    if (gap_in_month(intended_date, last_date))
      intended_date = (intended_date - 1.month).to_end_of_month
    end
    intended_date
  end

  def gap_in_month(date_one, date_two)
    date_one.year == date_two.year && ((date_one.month - date_two.month) > 1)
  end

  def compute_missing_hash
    self[:missing_hash] = HashService.compute_missing_hash(self)
  end

  def shift_needed
    (self[:amount] > 0 && debit?) || (self[:amount] < 0 && credit?)
  end
end
