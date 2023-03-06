class CommunitiesController < ApplicationController

  before_action :correct_user, only: [:edit, :update, :destroy]

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
      @community = Community.new
      render 'new'
    end
  end

  def index #homes#topに統合
  end

  def detail
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  def show
    @community = Community.find(params[:id])
    @user = User.find(current_user.id)
    @nextMeeting = Meeting.find_by(community_id:  params[:id], status: 0) #実施前のMTG
    if @nextMeeting.present? #次のミーティングまでのカウントダウン実装javascriptに使う数値を定義。
      if @nextMeeting.date.present?
        gon.year = @nextMeeting.date.year
        gon.month = @nextMeeting.date.month
        gon.day = @nextMeeting.date.day
      end
    end
    @meetingsInProgress = Meeting.where(community_id: params[:id], status: 1) #実施中のMTG
    @rules = Rule.where(community_id: params[:id])
    @mottos = Motto.where(community_id: params[:id])
    @records = Record.where(community_id: params[:id], updated_at: Time.zone.today.ago(30.days)..Time.zone.today.end_of_day).order(updated_at: :desc).limit(10)
    @goal = Goal.find_by(community_id: params[:id])
    if @goal.present? #if文にしないとなぜかエラーがでる。
      gon.deadline = @goal.deadline #gem 'gon'を利用してRailsからJavaScriptオブジェクトに変換
    end
    @excutedRules = Standby.where(community_id: params[:id], action_type: "rule", created_at: Time.current.all_month) #今月created_atのデータに絞っている。
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  def join_request
    @community = Community.find(params[:community_id])
    @community.users << current_user
    redirect_to top_path
  end

  def accept #rules#receiveで承認許可したユーザーのstatusを2に変える
    user = CommunityUser.find(params[:id])
    user.status = 1
    user.save!
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
    @currentUser = CommunityUser.find_by(user_id: current_user.id) #community-info表示に利用
  end

  def update
    community = Community.find(params[:id])
    community.update(community_params)
    redirect_to community_detail_path(community.id)
  end

  private

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id, :manual, :genre)
  end

  def motto_params
    params.require(:motto).permit(:content)
  end

  def rule_params
    params.require(:rule).permit(:content, :point, :genre, :date)
  end

  def correct_user
    @community = Community.find(params[:id])
    unless @community.owner_id == current_user.id
      redirect_to top_path
      #「オーナーのみ設定可能です」のnotice
    end
  end

end
