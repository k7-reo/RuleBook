class GoalsController < ApplicationController

  before_action :community_user, only: [:new, :create, :edit, :update, :index, :destroy, :achieved, :unachieved]

  def new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
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
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    @goal = Goal.find(params[:id])
  end

  def update
    community = Community.find(params[:community_id])
    goal = Goal.find(params[:id])
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

  def index
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    @activeGoal = Goal.find_by(community_id: params[:community_id], status: true)
    @pastGoals = Goal.where(community_id: params[:community_id], status: false).order(updated_at: :desc)
  end

  def destroy
    community = Community.find(params[:community_id])
    goal = Goal.find(params[:id])
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

  def achieved #達成ctaクリック
    community = Community.find(params[:community_id])
    goal = Goal.find_by(community_id: params[:community_id], id: params[:goal_id])
    goal.achievement = true
    goal.status = false
    goal.save
    redirect_to community_goals_path(community.id)
  end

  def unachieved #未達成ctaクリック
    community = Community.find(params[:community_id])
    goal = Goal.find_by(community_id: params[:community_id], id: params[:goal_id])
    goal.status = false
    goal.save
    redirect_to community_goals_path(community.id)
  end

  private

  def goal_params
    params.require(:goal).permit(:community_id, :user_id, :content, :deadline, :startline)
  end

  def community_user
    community =  Community.find(params[:community_id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

end
