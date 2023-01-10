class MottosController < ApplicationController

  def index
    @community = Community.find(params[:community_id]) #mottoparamsとcommunityparamasのうちcommunityのid
  end

  def new
    @motto = Motto.new #空のインスタンス作成(motto.idは作成されるが内容が空)
    @community = Community.find(params[:community_id]) #コミュニティTOPに戻るprefixで使用
  end

  def create #mottoテーブルとrecordテーブルへの新規レコード作成
    @community = Community.find(params[:community_id]) #どのcommunityのモットーか指定するために抽出。
    motto = Motto.new(motto_params)
    motto.user_id = current_user.id #mottoモデル内のuser_idにcurrent_usre.idを当てはめる
    motto.community_id = @community.id #mottoモデル内のuser_idにcurrent_usre.idを当てはめる
    motto.save
    #履歴登録↓
    newRecord = Record.new
    newRecord.community_id = @community.id
    newRecord.motto_id = motto.id
    newRecord.content = motto.content
    newRecord.user_id = current_user.id
    newRecord.updating_user_id = current_user.id
    newRecord.version = 1 #1→作成
    newRecord.action_type = "Motto"
    newRecord.save
    redirect_to community_mottos_path(@community.id)
  end

  def edit
    @community = Community.find(params[:community_id])
    @motto = Motto.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    motto = Motto.find(params[:id])
    motto.update(motto_params)
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

end