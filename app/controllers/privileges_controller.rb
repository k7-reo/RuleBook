class PrivilegesController < ApplicationController

  before_action :community_user, only: [:index, :new, :create, :edit, :update, :destroy, :execute]

  def index #penalties#indexもここで定義
    @community = Community.find(params[:community_id])
    @user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    @activePrivileges = Privilege.where("community_id = ? and point <= ?", @community.id, @user.monthly_point) #whereの変異系：community_idが@community.idでpointが@user.monthly_pointのレコード取得。
    @activePenalties = Penalty.where("community_id = ? and -(point) >= ?", @community.id, @user.monthly_point)
  end

  def new
    @privilege = Privilege.new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def create
    @community = Community.find(params[:community_id])
    @privilege = Privilege.new(privilege_params)
    @privilege.user_id = current_user.id
    @privilege.community_id = @community.id
    if @privilege.save
      #履歴登録↓
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.privilege_id = @privilege.id
      newRecord.content = @privilege.content
      newRecord.point = @privilege.point
      newRecord.user_id = current_user.id
      newRecord.updating_user_id = current_user.id
      newRecord.version = 1
      newRecord.action_type = "Privilege"
      newRecord.save
      redirect_to community_privileges_path(@community.id)
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'new'
    end
  end

  def edit
    @community = Community.find(params[:community_id])
    @privilege = Privilege.find(params[:id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def update
    @community = Community.find(params[:community_id])
    @privilege = Privilege.find(params[:id])
    @privilege.updating_user_id = current_user.id
    if @privilege.update(privilege_params)
      #履歴登録↓
      oldRecord = Record.find_by(privilege_id: @privilege.id)
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.privilege_id = @privilege.id
      newRecord.content = @privilege.content
      newRecord.point = @privilege.point
      newRecord.user_id = @privilege.user_id
      newRecord.updating_user_id = current_user.id
      newRecord.version = oldRecord.version + 1
      newRecord.action_type = "Privilege"
      newRecord.save
      redirect_to community_privileges_path(@community.id)
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'edit'
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    privilege = Privilege.find(params[:id])
    #履歴登録↓
    newRecord = Record.new
    newRecord.community_id = @community.id
    newRecord.privilege_id = privilege.id
    newRecord.content = privilege.content
    newRecord.point = privilege.point
    newRecord.user_id = privilege.user_id
    newRecord.updating_user_id = current_user.id
    newRecord.version = 0
    newRecord.action_type = "Privilege"
    newRecord.save
    privilege.destroy
    redirect_to community_privileges_path(@community.id)
  end

  def execute
    @community = Community.find(params[:community_id])
    community_user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
    privilege = Privilege.find(params[:privilege_id])
    community_user.monthly_point -= privilege.point
    community_user.save
    standby = Standby.new
    standby.community_id = @community.id
    standby.privilege_id = privilege.id
    standby.action_type = 'privilege'
    standby.executing_user_id = current_user.id
    standby.executed_user_id = current_user.id
    standby.content = privilege.content
    standby.point = privilege.point
    standby.checked = true
    standby.approval = true
    if standby.save
      @message = "報酬の取得を完了しました。"
      redirect_to community_privileges_path(@community.id), notice: @message
    end
  end

  private

  def privilege_params
    params.require(:privilege).permit(:content, :point, :community_id, :use_id)
  end

  def penalty_params
    params.require(:penalty).permit(:content, :point, :community_id, :creating_user_id, :permitting_user_id, :punished_user_id, :status)
  end

  def community_user
    community =  Community.find(params[:community_id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

end
