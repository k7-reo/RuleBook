class GoalsController < ApplicationController

  def new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @goal = Goal.new
  end

  def create
    community = Community.find(params[:community_id])
    goal = Goal.new(goal_params)
    goal.user_id = current_user.id
    goal.community_id = community.id
    goal.save
    redirect_to community_path(community.id)
    #履歴登録↓
    newRecord = Record.new
    newRecord.community_id = community.id
    newRecord.goal_id = goal.id
    newRecord.content = goal.content
    newRecord.user_id = current_user.id
    newRecord.updating_user_id = current_user.id
    newRecord.version = 1 #1→作成
    newRecord.action_type = "Goal"
    newRecord.save
  end

  def edit
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @goal = Goal.find_by(community_id: params[:community_id])
  end

  def update
    community = Community.find(params[:community_id])
    goal = Goal.find_by(community_id: params[:community_id])
    goal.update(goal_params)
    redirect_to community_path(community.id)
    #履歴登録↓
    oldRecord = Record.find_by(goal_id: goal.id)
    newRecord = Record.new
    newRecord.community_id = community.id
    newRecord.goal_id = goal.id
    newRecord.content = goal.content
    newRecord.user_id = goal.user_id
    newRecord.updating_user_id = current_user.id
    newRecord.version = oldRecord.version + 1
    newRecord.action_type = "Goal"
    newRecord.save
  end

  def show
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
    @goal = Goal.find_by(community_id: params[:community_id])
  end

  def destroy
    community = Community.find(params[:community_id])
    goal = Goal.find_by(community_id: params[:community_id])
    #履歴登録↓
    record = Record.new
    record.community_id = community.id
    record.goal_id = goal.id
    record.content = goal.content
    record.user_id = goal.user_id
    record.updating_user_id = current_user.id
    record.version = 0
    record.action_type = "Goal"
    record.save
    goal.destroy
    redirect_to community_path(community.id)
  end

  private

  def goal_params
    params.require(:goal).permit(:community_id, :user_id, :content, :deadline)
  end

end
