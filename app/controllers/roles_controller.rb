class RolesController < ApplicationController

  def new
    @community = Community.find(params[:community_id])
    @user = User.find(params[:user_id])
    @role = Role.new
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  def create
    community = Community.find(params[:community_id])
    role = Role.new(role_params)
    role.user_id = current_user.id
    role.community_id = community.id
    role.save
    redirect_to community_user_mypage_path(community.id, current_user.id)
  end

  def edit
    @community = Community.find(params[:community_id])
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  def update
    community = Community.find(params[:community_id])
    role = Role.find(params[:id])
    role.update(role_params)
    redirect_to community_user_mypage_path(community.id, current_user.id)
  end

  def index #mypageに表示
  end

  def destroy
    community = Community.find(params[:community_id])
    role = Role.find(params[:id])
    role.destroy
    redirect_to community_user_mypage_path(community.id, current_user.id)
  end

  private

  def role_params
    params.require(:role).permit(:community_id, :user_id, :content)
  end

end
