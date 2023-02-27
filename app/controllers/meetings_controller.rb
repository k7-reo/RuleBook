class MeetingsController < ApplicationController

  def new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
    @meeting = Meeting.new
  end

  def create
    @community = Community.find(params[:community_id])
    meeting = Meeting.new(meeting_params)
    meeting.community_id = @community.id
    meeting.user_id = current_user.id
    meeting.status = 0
    meeting.save
    redirect_to community_meetings_path(@community.id)
  end

  def pre_edit
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
    @meeting = Meeting.find(params[:meeting_id])
  end

  def edit
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id)
    @meeting = Meeting.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    meeting = Meeting.find(params[:id])
    if params[:save]
    elsif params[:done]
    end
    meeting.update(meeting_params)
    redirect_to community_meetings_path(@community.id)
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
