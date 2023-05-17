class MottosController < ApplicationController

  before_action :community_user, only: [:new, :create, :edit, :update, :index, :destroy]

  def index
    @community = Community.find(params[:community_id]) #mottoparamsとcommunityparamasのうちcommunityのid
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def new
    @motto = Motto.new #空のインスタンス作成(motto.idは作成されるが内容が空)
    @community = Community.find(params[:community_id]) #コミュニティTOPに戻るprefixで使用
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def create #mottoテーブルとrecordテーブルへの新規レコード作成
    @community = Community.find(params[:community_id]) #どのcommunityのモットーか指定するために抽出。
    @motto = Motto.new(motto_params)
    @motto.user_id = current_user.id #mottoモデル内のuser_idにcurrent_usre.idを当てはめる
    @motto.community_id = @community.id #mottoモデル内のuser_idにcurrent_usre.idを当てはめる
    if @motto.save
      #履歴登録↓
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.motto_id = @motto.id
      newRecord.content = @motto.content
      newRecord.user_id = current_user.id
      newRecord.updating_user_id = current_user.id
      newRecord.version = 1 #1→作成
      newRecord.action_type = "Motto"
      newRecord.save
      redirect_to community_mottos_path(@community.id)
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'new'
    end
  end

  def edit
    @community = Community.find(params[:community_id])
    @motto = Motto.find(params[:id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def update
    @community = Community.find(params[:community_id])
    @motto = Motto.find(params[:id])
    if @motto.update(motto_params)
      redirect_to community_mottos_path(@community.id)
      #履歴登録↓
      oldRecord = Record.find_by(motto_id: @motto.id)
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.motto_id = @motto.id
      newRecord.content = @motto.content
      newRecord.user_id = @motto.user_id
      newRecord.updating_user_id = current_user.id
      newRecord.version = oldRecord.version + 1
      newRecord.action_type = "Motto"
      newRecord.save
    else
      @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
      render 'edit'
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    @motto = Motto.find(params[:id])
    #履歴登録↓
    record = Record.new
    record.community_id = @community.id
    record.motto_id = @motto.id
    record.content = @motto.content
    record.user_id = @motto.user_id
    record.updating_user_id = current_user.id
    record.version = 0
    record.action_type = "Motto"
    record.save
    @motto.destroy #レコード作成してから削除しないと、レコードで@motto参照できない。はず。
    redirect_to community_mottos_path(@community.id)
  end

  private

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id)
  end

  def motto_params
    params.require(:motto).permit(:content)
  end

  def community_user
    community =  Community.find(params[:community_id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

end