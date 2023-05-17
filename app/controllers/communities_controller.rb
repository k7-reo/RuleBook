class CommunitiesController < ApplicationController

  before_action :community_owner, only: [:edit, :update, :destroy, :accept]
  before_action :community_user, only: [:show]

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.owner_id = current_user.id
    @community.users << current_user
    #CommunityUserの当該ユーザーのstatusを1にしたい
    if @community.save
      community_user = CommunityUser.find_by(user_id: current_user.id, community_id: @community.id)
      community_user.status = 1
      community_user.save
      redirect_to community_path(@community)
    else
      render 'new'
    end
  end

  def index #homes#topに統合
  end

  def show
    @community = Community.find(params[:id])
    @communityUsers = CommunityUser.where(community_id: params[:id], status: 1)
    @user = User.find(current_user.id)
    @nextMeeting = Meeting.find_by(community_id:  params[:id], status: 0) #実施前のMTG
    if @nextMeeting.present? #次のミーティングまでのカウントダウン実装javascriptに使う数値を定義。
      if @nextMeeting.date.present?
        gon.year = @nextMeeting.date.year
        gon.month = @nextMeeting.date.month
        gon.day = @nextMeeting.date.day
      end
    end
    @meetingsInProgress = Meeting.find_by(community_id: params[:id], status: 1) #実施中のMTG
    @rules = Rule.where(community_id: params[:id])
    @mottos = Motto.where(community_id: params[:id])
    @records = Record.where(community_id: params[:id], updated_at: Time.zone.today.ago(30.days)..Time.zone.today.end_of_day).order(updated_at: :desc)
    @goal = Goal.find_by(community_id: params[:id], status: true)
    if @goal.present? #if文にしないとなぜかエラーがでる。
      #deadlineの文字カウントダウン
      gon.deadline = @goal.deadline #gem 'gon'を利用してRailsからJavaScriptオブジェクトに変換
      #deadlineのラインカウントダウン
      if @goal.deadline.present?
        now = Time.current
        if @goal.startline.present? #startが指定されてない時は、updated＿atをスタートにする
          startline = @goal.startline
        else @goal.startline.present?
          startline = @goal.created_at
        end
        total_time = @goal.deadline - startline
        passed_time = now - startline
        remaining_time = @goal.deadline - now
        @passed_ratio = (passed_time.to_f / total_time).clamp(0, 1)
        @remaining_ratio = (remaining_time.to_f / total_time).clamp(0, 1)
      end
    end
    @excutedRules = Standby.where(community_id: params[:id], action_type: "rule", created_at: Time.current.all_month) #今月created_atのデータに絞っている。
    @coupleAdvice = Advice.where(community_genre: "夫婦・カップル").order("RANDOM()").first
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:id]) #community-info表示に利用
    @acceptedUsers = CommunityUser.where(community_id: params[:id], status: 1)
    #ゴールtimelineの表示
  end

  def join_request
    @community = Community.find(params[:community_id])
    @community.users << current_user
    redirect_to top_path
  end

  def accept #rules#receiveで承認許可したユーザーのstatusを1に変える
    user = CommunityUser.find(params[:id])
    user.status = 1
    user.save!
    redirect_to receive_path
  end
  
  def decline
    user = CommunityUser.find(params[:id])
    user.destroy
    redirect_to receive_path
  end

  def out
    @community = Community.find(params[:community_id])
    @community.users.delete(current_user)
    redirect_to top_path
  end

  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    redirect_to top_path
  end

  def edit
    @community = Community.find(params[:id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:id]) #community-info表示に利用
  end

  def update
  @community = Community.find(params[:id])
  if @community.update(community_params)
    @community.community_image.attach(params[:community][:community_image])
    if params[:default_background]
      @community.community_image = nil
    end
    redirect_to community_path(@community.id)
  else
    render 'edit'
  end
end

  private

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id, :manual, :genre, :community_image)
  end

  def motto_params
    params.require(:motto).permit(:content)
  end

  def rule_params
    params.require(:rule).permit(:content, :point, :genre, :date)
  end

  def community_owner
    community = Community.find(params[:id])
    unless community.owner_id == current_user.id
      redirect_to top_path
      #「オーナーのみ設定可能です」のnotice
    end
  end

  def community_user
    community =  Community.find(params[:id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

end
