# Model for stock, with several class functions
class Stock < ActiveRecord::Base
  has_many :user_stocks
  has_many :users, through: :user_stocks

  class << self
    def new_from_lookup(ticker)
      looked_up = StockQuote::Stock.quote(ticker)

      return nil unless looked_up.name

      new_stock = new(ticker: looked_up.symbol, name: looked_up.name)
      new_stock.last_price = new_stock.price
      new_stock
    end

    def find_by_ticker(ticker)
      where(ticker: ticker).first
    end
  end

  def price
    stock = StockQuote::Stock.quote(ticker)

    if stock
      closing = stock.close
      return "#{closing} (Closing)" if closing

      opening = stock.open
      return "#{opening} (Opening)" if opening
    end

    'Unavailable'
  end
end
