class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable  # :recoverable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def can_add_stock?(ticker)
    under_stock_limit? &&
      !stock_already_added?(ticker)
  end

  def under_stock_limit?
    user_stocks.count < 10
  end

  def stock_already_added?(ticker)
    stock = Stock.find_by_ticker ticker
    return false unless stock

    user_stocks.where(stock_id: stock.id).exists?
  end

  def search

  end
end
