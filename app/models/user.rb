# Model for User
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  class << self
    def search(param)
      return user.none if param.blank?

      param.strip!
      param.downcase!

      (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    end

    def first_name_matches(param)
      matches('first_name', param)
    end

    def last_name_matches(param)
      matches('last_name', param)
    end

    def email_matches(param)
      matches('email', param)
    end

    def matches(field_name, param)
      where("LOWER(#{field_name}) LIKE ?", "%#{param}%")
    end
  end

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

  def not_friends_with?(other)
    friendships.where(friend_id: other.id).count < 1
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end
end
