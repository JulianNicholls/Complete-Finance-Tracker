# Model for stock, with several class functions
class Stock < ActiveRecord::Base
  has_many :user_stocks
  has_many :users, through: :user_stocks

  class << self
    def new_from_lookup(ticker)
      looked_up = StockTicker.new(ticker)

      name = looked_up.name

      return nil unless name

      new_stock = new(ticker: looked_up.symbol, name: name)
      new_stock.last_price = new_stock.price
      new_stock
    end

    def find_by_ticker(ticker)
      where(ticker: ticker).first
    end
  end

  def price
    StockTicker.new(ticker).price
  end
end

# Shim for stock_quote gem
class StockTicker
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
    @ticker = StockQuote::Stock.quote(symbol)
  end

  def price
    return "#{closing} (Closing)" if closing
    return "#{opening} (Opening)" if opening

    'Unavailable'
  end

  def name
    @ticker.name
  end

  private

  def closing
    @ticker.close
  end

  def opening
    @ticker.open
  end
end
