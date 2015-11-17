# Controller fur users
class UsersController < ApplicationController
  def show
    @user        = User.find params[:id]
    @user_stocks = @user.stocks
  end

  def my_portfolio
    @user        = current_user
    @user_stocks = @user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    @users = User.search params[:search_param]

    if @users
      @users = current_user.except_current_user @users
      render partial: 'friends/lookup'
    else
      render status: :not_found, nothing: true
    end
  end

  def add_friend
    @friend = User.find params[:friend]

    current_user.friendships.build friend: @friend
    if current_user.save
      redirect_to my_friends_path, notice: 'That friend has been added.'
    else
      redirect_to my_friends_path,
                  flash[:error] = 'There was an error with adding that friend.'
    end
  end
end
