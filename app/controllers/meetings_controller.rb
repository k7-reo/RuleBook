class MeetingsController < ApplicationController

  def new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
  end

  def create
    @community = Community.find(params[:community_id])
  end

  def edit
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
  end

  def update
    @community = Community.find(params[:community_id])
  end

  def destroy
    @community = Community.find(params[:community_id])
  end

  def index
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  private

  def meeting_params
    params.require(:meeting).permit(:name, :community_id, :user_id, :content, :todo, :agenda, :next_agenda, :date, :next_date, :status)
  end

end
