class RulesController < ApplicationController


  def index
    @community = Community.find(params[:community_id]) #意味：Communityモデルから該当するidのレコードをfind(探し出す)する。findはidしか引数にできない。paramがないとcontorollerはデータを受け取れない。アクションないでrule_idも呼び出されているので、しっかり[:community_id]を指定。
  end

  def show
    @rule = Rule.find(params[:id])
    @community = Community.find(params[:community_id])
  end

  def new
    @rule = Rule.new
    @community = Community.find(params[:community_id])
  end

  def create
    @community = Community.find(params[:community_id])
    rule = Rule.new(rule_params)
    rule.user_id = current_user.id
    rule.community_id = @community.id
    rule.save
    redirect_to community_rules_path(@community.id)
  end

  def destroy
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:id])
    @rule.destroy
    redirect_to community_rules_path(@community.id)
  end

  def edit
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    rule = Rule.find(params[:id])
    rule.updating_user_id = current_user.id
    rule.update(rule_params)
    redirect_to community_rules_path(@community.id)
  end

  def execute #ルール実行html表示のアクション
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:rule_id])
    @standby = Standby.new
  end

  def execute_create #ルール実行htmlから申請、待機テーブルへの登録までのアクション
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:rule_id])
    standby = Standby.new(standby_params)
    standby.executing_user_id = current_user.id
    standby.community_id = @community.id
    standby.rule_id = @rule.id
    standby.action_type = 'rule'
    standby.save!
    redirect_to community_rules_path(@community.id)
  end

  def receive #ルール実行申請を受けての承認/否認のアクション(notificationアクションが実装できたら移行)
    @user = current_user
    @standbyRules = Standby.where(action_type: 'rule', executed_user_id: current_user.id, checked: false).order(created_at: :asc) #ルール承認のため
    @standbyPenalties = Standby.where(action_type: 'penalty', executed_user_id: current_user.id, checked: false).order(created_at: :asc)
    @unaccepted_users = CommunityUser.joins(:community).where(status: 0).where(communities: {owner_id: current_user.id}) #コミュティ参加依頼受信のため
  end

  def approval
    standby = Standby.find(params[:id])
    @community_user = CommunityUser.find_by(user_id: standby.executed_user_id, community_id: standby.community_id)#whereは条件にあっているデータを複数とってくる。今回は1つのデータを取る前提なのでfind_byを利用。
    @community_user.point += standby.rule.point
    @community_user.save
    standby.checked = true #true=確認済み。今後ユーザーが受けてきたルールのカウントをする際には、trueの数をカウントすればいい。
    standby.save
    redirect_to receive_path
  end

  def denial
    standby = Standby.find(params[:id])
    standby.checked = true
    standby.save
    redirect_to receive_path
  end

  private

  def community_params
    params.require(:community).permit(:community_name, :introduction, :owner_id)
  end

  def rule_params
    params.require(:rule).permit(:content, :point, :genre, :community_id, :updating_user_id, :user_id)
  end

  def standby_params
    params.require(:standby).permit(:executing_user_id, :executed_user_id, :community_id, :rule_id).merge(executing_user_id: current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :body, :point)
  end

end
