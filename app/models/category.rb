class Category < ActiveRecord::Base
  belongs_to :user

  scope :debits_first, -> {order(category_type: :desc, group: :asc, description: :asc)}

  validates_presence_of :description, :group, :category_type, :frequency
  validate :only_debits_can_be_investment

  def only_debits_can_be_investment
    if investment?
      errors.add(:base, 'Only debits can be marked as an investment') unless debit?
    end
  end

  def full_description
    "#{group}/#{description}"
  end

  def debit?
    category_type.to_sym == :debit
  end

  def credit?
    !debit?
  end

  def monthly?
    frequency.to_sym == :monthly
  end

  def weekly?
    frequency.to_sym == :weekly
  end

  def daily?
    frequency.to_sym == :daily
  end

  def oftenly?
    frequency.to_sym == :oftenly
  end

end
