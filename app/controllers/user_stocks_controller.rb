# Controller fur user tracked stocks
class UserStocksController < ApplicationController
  # GET /user_stocks
  # GET /user_stocks.json
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # POST /user_stocks
  # POST /user_stocks.json
  def create
    @user_stock = create_record

    respond_to do |format|
      if @user_stock.save
        ticker = @user_stock.stock.ticker

        format.html do
          redirect_to my_portfolio_path,
                      notice: "The stock #{ticker} was successfully added."
        end
        format.json { render :show, status: :created, location: @user_stock }
      else
        format.html { render :new }
        format.json do
          render json: @user_stock.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /user_stocks/1
  # DELETE /user_stocks/1.json
  def destroy
    @user_stock = UserStock.find(params[:id])
    @user_stock.destroy

    respond_to do |format|
      format.html do
        redirect_to my_portfolio_path,
                    notice: 'The stock was successfully removed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the internet, only allow the white list through.
  def user_stock_params
    params.require(:user_stock).permit(:user_id, :stock_id)
  end

  def create_record
    if params[:stock_id].present?
      UserStock.new stock_id: params[:stock_id], user: current_user
    else
      create_from_stock_record
    end
  end

  def create_from_stock_record
    stock = Stock.find_by_ticker stock_ticker
    return record_from_stock(stock) if stock

    stock = Stock.new_from_lookup stock_ticker
    return record_from_stock(stock) if stock.save

    flash[:error] = 'The stock is not currently available.'
    nil
  end

  def record_from_stock(stock)
    UserStock.new stock: stock, user: current_user
  end

  def stock_ticker
    params[:stock_ticker]
  end
end
