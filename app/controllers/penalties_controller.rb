class PenaltiesController < ApplicationController

  before_action :community_user, only: [:new, :create, :edit, :update, :destroy, :execute, :execute_create]

  def new
    @penalty = Penalty.new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def create
    @community = Community.find(params[:community_id])
    @penalty = Penalty.new(penalty_params)
    @penalty.user_id = current_user.id
    @penalty.community_id = @community.id
    if @penalty.save
      #履歴登録↓
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.penalty_id = @penalty.id
      newRecord.content = @penalty.content
      newRecord.point = @penalty.point
      newRecord.user_id = current_user.id
      newRecord.updating_user_id = current_user.id
      newRecord.version = 1
      newRecord.action_type = "Penalty"
      newRecord.save
      redirect_to community_privileges_path(@community.id)
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'new'
    end
  end

  def edit
    @community = Community.find(params[:community_id])
    @penalty = Penalty.find(params[:id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def update
    @community = Community.find(params[:community_id])
    @penalty = Penalty.find(params[:id])
    @penalty.updating_user_id = current_user.id
    if @penalty.update(penalty_params)
      #履歴登録↓
      oldRecord = Record.find_by(penalty_id: @penalty.id)
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.penalty_id = @penalty.id
      newRecord.content = @penalty.content
      newRecord.point = @penalty.point
      newRecord.user_id = @penalty.user_id
      newRecord.updating_user_id = current_user.id
      newRecord.version = oldRecord.version + 1
      newRecord.action_type = "Penalty"
      newRecord.save
      redirect_to community_privileges_path(@community.id)
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'edit'
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    penalty = Penalty.find(params[:id])
    #履歴登録↓
    newRecord = Record.new
    newRecord.community_id = @community.id
    newRecord.penalty_id = penalty.id
    newRecord.content = penalty.content
    newRecord.point = penalty.point
    newRecord.user_id = penalty.user_id
    newRecord.updating_user_id = current_user.id
    newRecord.version = 0
    newRecord.action_type = "Penalty"
    newRecord.save
    penalty.destroy
    redirect_to community_privileges_path(@community.id)
  end

  def execute
    @community = Community.find(params[:community_id])
    @penalty = Penalty.find(params[:penalty_id])
    @standby = Standby.new
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def execute_create #penalty実行完了申請。この時点でcommunity_userのpointにポイント反映。否認されれば申請前のポイントに戻る。
    @community = Community.find(params[:community_id])
    @penalty = Penalty.find(params[:penalty_id])
    @standby = Standby.new(standby_params)
    @standby.executing_user_id = current_user.id
    @standby.community_id = @community.id
    @standby.penalty_id = @penalty.id
    @standby.content = @penalty.content
    @standby.point = @penalty.point
    @standby.action_type = 'penalty'
    if @standby.save
      community_user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
      community_user.monthly_point += @standby.point
      community_user.save
      @message = "ペナルティの承認申請を送りました。"
      redirect_to community_privileges_path(@community.id), notice: @message
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'execute'
    end
  end

  def forgive #penalty実行承認
    standby = Standby.find(params[:id])
    #community_user = CommunityUser.find_by(user_id: standby.executed_user_id, community_id: standby.community_id)#whereは条件にあっているデータを複数とってくる。今回は1つのデータを取る前提なのでfind_byを利用。
    #community_user.point += standby.penalty.point
    #community_user.save
    standby.checked = true #true=確認済み。今後ユーザーが受けてきたルールのカウントをする際には、trueの数をカウントすればいい。
    standby.approval = true
    standby.save
    redirect_to receive_path
  #  excuting_userのreceiveに「許可が通りました。」notice
  end

  def forbid #penalty実行否認
    standby = Standby.find(params[:id])
    community_user = CommunityUser.find_by(user_id: standby.executed_user_id, community_id: standby.community_id)#whereは条件にあっているデータを複数とってくる。今回は1つのデータを取る前提なのでfind_byを利用。
    community_user.monthly_point -= standby.point
    community_user.save
    standby.checked = true
    standby.save
    redirect_to receive_path
  # excuting_userのreceiveに 「許可を得られませんでした。」notice
  end

  private

  def penalty_params
    params.require(:penalty).permit(:content, :point, :community_id, :creating_user_id, :permitting_user_id, :punished_user_id, :status)
  end

  def standby_params
    params.require(:standby).permit(:executing_user_id, :executed_user_id, :community_id, :penalty_id, :action_type).merge(executing_user_id: current_user.id)
  end

  def community_user
    community =  Community.find(params[:community_id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

end
