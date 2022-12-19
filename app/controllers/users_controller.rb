class UsersController < ApplicationController

  def index
    #@users = User.joins(:community_users).where(community_users: {community_id: params[:community_id]}) #joinsでuserモデルとcommunityモデルのデータを結合したテーブルを作る。(ちなみに中間テーブルは２つの多対多の関連を示すもの)
    @communityUsers = CommunityUser.where(community_id: params[:community_id])
    @community = Community.find(params[:community_id])
  end

  def show
    @user = CommunityUser.find_by(user_id: params[:id])
    @community = Community.find(params[:community_id])
    @rules = Rule.where(user_id: params[:id], community_id: params[:community_id])
    @penalties = Penalty.where(user_id: params[:id], community_id: params[:community_id])
    @privileges = Privilege.where(user_id: params[:id], community_id: params[:community_id])
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def update
    user = User.find_by(id: current_user.id)
    user.update(user_params)
    redirect_to setting_path
  end
  
  def mypage
    @community = Community.find(params[:community_id])
    @user = CommunityUser.find_by(id: current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id)
  end

end
