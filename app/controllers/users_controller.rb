class UsersController < ApplicationController

  def index
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @communityUsers = CommunityUser.where(community_id: params[:community_id]).order(point: :desc)
    @community = Community.find(params[:community_id])
  end

  def show
    @user = CommunityUser.find_by(user_id: params[:id])
    @community = Community.find(params[:community_id])
    @rules = Rule.where(user_id: params[:id], community_id: @community.id)
    @penalties = Penalty.where(user_id: params[:id], community_id: @community.id)
    @privileges = Privilege.where(user_id: params[:id], community_id: @community.id)
    @roles = Role.where(user_id: params[:id], community_id: @community.id)
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def update
    user = User.find_by(id: current_user.id)
    user.update(user_params)
    redirect_to setting_path
  end

  def mypage
    @community = Community.find(params[:community_id])
    @user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
    @activePrivileges = Privilege.where("community_id = ? and point <= ?", @community.id, @user.monthly_point) #whereの変異系：community_idが@community.idでpointが@user.monthly_pointのレコード取得。
    @activePenalties = Penalty.where("community_id = ? and -(point) >= ?", @community.id, @user.monthly_point)
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @roles = Role.where(user_id: current_user.id, community_id: @community.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id)
  end

end
