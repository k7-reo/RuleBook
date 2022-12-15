class PrivilegesController < ApplicationController

  def index #penalties#indexもここで定義
    @community = Community.find(params[:community_id])
    @user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
  end

  def new
    @privilege = Privilege.new
    @community = Community.find(params[:community_id])
  end

  def create
    @community = Community.find(params[:community_id])
    privilege = Privilege.new(privilege_params)
    privilege.user_id = current_user.id
    privilege.community_id = @community.id
    privilege.save
    redirect_to community_privileges_path(@community.id)
  end

  def edit
    @community = Community.find(params[:community_id])
    @privilege = Privilege.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    @privilege = Privilege.find(params[:id])
    @privilege.update(privilege_params)
    redirect_to community_privileges_path(@community.id)
  end

  def destroy
    @community = Community.find(params[:community_id])
    @privilege = Privilege.find(params[:id])
    @privilege.destroy
    redirect_to community_privileges_path(@community.id)
  end

  def execute
    @community = Community.find(params[:community_id])
    community_user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
    privilege = Privilege.find(params[:privilege_id]) #urlにidが複数あるのでどのidなのか指定する
    community_user.monthly_point -= privilege.point
    community_user.save
    redirect_to community_privileges_path(@community.id)
  end

  private

  def privilege_params
    params.require(:privilege).permit(:content, :point, :community_id, :use_id)
  end

  def penalty_params
    params.require(:penalty).permit(:content, :point, :community_id, :creating_user_id, :permitting_user_id, :punished_user_id, :status)
  end

end
