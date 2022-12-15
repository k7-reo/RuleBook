class MottosController < ApplicationController

  def index
    @community = Community.find(params[:community_id]) #mottoparamsとcommunityparamasのうちcommunityのid
  end

  def new
    @motto = Motto.new #空のインスタンス作成(motto.idは作成されるが内容が空)
    @community = Community.find(params[:community_id]) #コミュニティTOPに戻るprefixで使用
  end

  def create
    @community = Community.find(params[:community_id]) #どのcommunityのモットーか指定するために抽出。
    motto = Motto.new(motto_params)
    motto.user_id = current_user.id #mottoモデル内のuser_idにcurrent_usre.idを当てはめる
    motto.community_id = @community.id #mottoモデル内のuser_idにcurrent_usre.idを当てはめる
    motto.save
    redirect_to community_mottos_path(@community.id)
  end

  def edit
    @community = Community.find(params[:community_id])
    @motto = Motto.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    @motto = Motto.find(params[:id])
    @motto.update(motto_params)
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