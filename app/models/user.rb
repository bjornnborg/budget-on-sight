class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :categories, dependent: :destroy
  has_many :transactions, dependent: :destroy do 

    def since(date)
      where('date >= ?', date.at_beginning_of_day)
    end

    def until(date)
      where('date <= ?', date.at_end_of_day)
    end

    def balance
      all.sum(:amount)
    end
    
  end
end
