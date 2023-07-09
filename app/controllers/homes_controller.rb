class HomesController < ApplicationController

  before_action :authenticate_user!,except: [:home]

  def home
  end

  def top
    #自分が参加しているコミュニティのみ表示↓ ※下記インスタンス変数でview書き加える必要ある
    @myCommunities = Community.joins(:community_users).where(community_users: {user_id: current_user.id, status: 1}) #結合テーブルcommunity_usersからcurrent_userの所属するcommunityのみ抽出
    @ownerCommunity = Community
    @requestingCommunities = Community.joins(:community_users).where(community_users: {user_id: current_user.id, status: 0})
    @searchedCommunities = Community.search(params[:keyword])
  end

  def policy
    render 'homes/privacy_policy'
  end

  def terms
    render 'homes/terms_of_service'
  end

  private

end