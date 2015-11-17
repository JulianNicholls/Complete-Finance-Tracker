class FriendshipsController < ApplicationController
  def destroy
    friend = current_user.friendships.where(friend_id: params[:id]).first
    friend.destroy
    respond_to do |format|
      format.html { redirect_to my_friends_path, notice: 'The friend was removed successfully' }
    end
  end
end
