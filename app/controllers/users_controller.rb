class UsersController < ApplicationController

  before_action :community_user, only: [:index, :show]
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :my_page_user, only: [:mypage]

  def index
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    @communityUsers = CommunityUser.where(community_id: params[:community_id], status: 1).order(point_abs: :desc)
    @community = Community.find(params[:community_id])
    @index = "0"
  end

  def show
    @user = CommunityUser.find_by(user_id: params[:id], community_id: params[:community_id]) #community-info表示に利用
    @community = Community.find(params[:community_id])
    @communityUsers = CommunityUser.where(community_id: params[:community_id], status: 1).order(point_abs: :desc)
    @targetingPositiveRules = Rule.joins(:rule_users).where("rules.community_id = ? and rules.point >= 0", params[:community_id] ).where('rule_users.user_id' => params[:id])
    @targetingNegativeRules = Rule.joins(:rule_users).where("rules.community_id = ? and rules.point < 0", params[:community_id] ).where('rule_users.user_id' => params[:id])
    @executedRules = Standby.where(executed_user_id: params[:id], community_id: @community.id, action_type: "rule", approval: "true", updated_at: Time.current.all_month).order(updated_at: :desc)
    @finishedPrivileges = Standby.where(executing_user_id: params[:id], community_id: @community.id, action_type: "privilege", approval: "true", updated_at: Time.current.all_month).order(updated_at: :desc)
    @finishedPenalties = Standby.where(executing_user_id: params[:id], community_id: @community.id, action_type: "penalty", approval: "true", updated_at: Time.current.all_month).order(updated_at: :desc)
    @roles = Role.where(user_id: params[:id], community_id: @community.id)
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def update
    @user = User.find_by(id: current_user.id)
    if @user.update(user_params)
      @user.profile_image.attach(params[:user][:profile_image])
      redirect_to top_path
    else
      render 'edit'
    end
  end

  def mypage
    @community = Community.find(params[:community_id])
    @user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
    @activePrivileges = Privilege.where("community_id = ? and point <= ?", @community.id, @user.monthly_point) #whereの変異系：community_idが@community.idでpointが@user.monthly_pointのレコード取得。
    @activePenalties = Penalty.where("community_id = ? and -(point) >= ?", @community.id, @user.monthly_point)
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    @myRoles = Role.where(user_id: current_user.id, community_id: @community.id)
    @executedRules = Standby.where(executed_user_id: current_user.id, community_id: @community.id, action_type: "rule", approval: "true", updated_at: Time.current.all_month).order(updated_at: :desc)
    @finishedPrivileges = Standby.where(executing_user_id: current_user.id, community_id: @community.id, action_type: "privilege", approval: "true", updated_at: Time.current.all_month).order(updated_at: :desc)
    @finishedPenalties = Standby.where(executing_user_id: current_user.id, community_id: @community.id, action_type: "penalty", approval: "true", updated_at: Time.current.all_month).order(updated_at: :desc)
    @communityUsers = CommunityUser.where(community_id: params[:community_id], status: 1).order(point_abs: :desc)

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id)
  end

  def community_user_params
    params.require(:community_user).permit(:memo)
  end

  def community_user
    community =  Community.find(params[:community_id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

  def my_page_user
    myPageUser = User.find(params[:user_id])
    unless myPageUser.id == current_user.id
      redirect_to top_path
    end
  end
  
end
