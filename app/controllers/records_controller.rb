class RecordsController < ApplicationController

  def index
    @community = Community.find(params[:community_id]) #community-info表示に利用
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @records = Record.where(community_id: params[:community_id], updated_at: Time.zone.today.ago(30.days)..Time.zone.today.end_of_day).order(updated_at: :desc)
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end
end
