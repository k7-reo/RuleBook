class HomesController < ApplicationController

  before_action :authenticate_user!,except: [:home]

  def home
  end

  def top
    #@communities = Community.all
    #自分が参加しているコミュニティのみ表示↓ ※下記インスタンス変数でview書き加える必要ある
    @my_communities = Community.joins(:community_users).where(community_users: {user_id: current_user.id, status: 1}) #結合テーブルcommunity_usersからcurrent_userの所属するcommunityのみ抽出
    @requesting_communities = Community.joins(:community_users).where(community_users: {user_id: current_user.id, status: 0})
    @searched_communities = Community.search(params[:keyword])
  end

  def setting
    @user = User.find_by(id: current_user.id)
  end

  def policy
  end

  private

end
