class RulesController < ApplicationController

  before_action :community_user, only: [:index, :new_positive, :new_negative, :create, :destroy, :edit, :update, :execute, :execute_create]

  def index
    @community = Community.find(params[:community_id]) #意味：Communityモデルから該当するidのレコードをfind(探し出す)する。findはidしか引数にできない。paramがないとcontorollerはデータを受け取れない。アクションないでrule_idも呼び出されているので、しっかり[:community_id]を指定。
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    @genres = Rule.distinct.pluck(:genre)
    @selected_genre = params[:genre] || "すべて"
    @rules = Rule.includes(:community).where(community_id: @community.id)
    if @selected_genre != "すべて"
      @rules = @rules.where(genre: @selected_genre)
    end
     # +ポイントのルールをジャンルでソート
    @positiveRules = @rules.where("point > 0").order(:genre)
    # -ポイントのルールをジャンルでソート
    @negativeRules = @rules.where("point <= 0").order(:genre)
  end

  def new_positive
    @rule = Rule.new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def new_negative
    @rule = Rule.new
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def create
    @community = Community.find(params[:community_id])
    #ruleレコード保存↓
    @rule = Rule.new(rule_params)
    @rule.user_id = current_user.id #ルール制作者
    @rule.community_id = @community.id
    @userIds=params[:rule][:user_ids] #[][]に連続※params[]の意味：送られてきた情報を受け取る。今回のcreateアクションではformに記載された情報をストロングパラメーターとして送っており、それを取得している。
    if @rule.save
      @userIds.each do |user_id| #user_idsで配列されているuser一人一人をruleに関連づける。(RuleUser中間テーブルに保存。)
        user = User.find(user_id.to_i)
        @rule.users << user #関連付ける。
      end
      ruleUsers = RuleUser.where(rule_id: @rule.id) #中間テーブルの各community_idの保存。
      ruleUsers.each do |user|
        user.community_id = params[:community_id]
        user.save
      end
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.rule_id = @rule.id
      newRecord.content = @rule.content
      newRecord.point = @rule.point
      newRecord.genre = @rule.genre
      newRecord.user_id = current_user.id
      newRecord.updating_user_id = current_user.id
      newRecord.version = 1
      newRecord.action_type = "Rule"
      newRecord.save
      redirect_to community_rules_path(@community.id)
    else
      render 'new'
    end
  end

  def destroy
    @community = Community.find(params[:community_id])
    rule = Rule.find(params[:id])
    #履歴登録↓
    newRecord = Record.new
    newRecord.community_id = @community.id
    newRecord.rule_id = rule.id
    newRecord.content = rule.content
    newRecord.point = rule.point
    newRecord.genre = rule.genre
    newRecord.user_id = rule.user_id
    newRecord.updating_user_id = current_user.id
    newRecord.version = 0
    newRecord.action_type = "Rule"
    newRecord.save
    rule.destroy
    redirect_to community_rules_path(@community.id)
  end

  def edit
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
    render "edit"
  end

  def update
    @community = Community.find(params[:community_id])
    rule = Rule.find(params[:id])
    rule.updating_user_id = current_user.id
    oldUserIds = rule.users.pluck(:id) #idを配列で取得
    newUserIds = params[:rule][:user_ids].map(&:to_i) #文字の配列として受け取ったidを数に変換
    if rule.update(rule_params)
      destroyUserIds = oldUserIds - newUserIds
      destroyUserIds.each do |destroy_user_id|
        user = RuleUser.find_by(rule_id: rule.id, user_id: destroy_user_id)
        user.destroy
      end
      newUserIds.each do |user_id|
        unless oldUserIds.include?(user_id)
          user = User.find(user_id)
          rule.users << user
        end
      end
      redirect_to community_rules_path(@community.id)
      #履歴登録↓
      oldRecord = Record.find_by(rule_id: rule.id)
      newRecord = Record.new
      newRecord.community_id = @community.id
      newRecord.rule_id = rule.id
      newRecord.content = rule.content
      newRecord.point = rule.point
      newRecord.genre = rule.genre
      newRecord.user_id = rule.user_id
      newRecord.updating_user_id = current_user.id
      newRecord.version = oldRecord.version + 1
      newRecord.action_type = "Rule"
      newRecord.save
    else
      render 'edit'
    end
  end

  def execute #ルール実行html表示のアクション
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:rule_id])
    @targetUsers = User.joins(:rule_users).where(rule_users: {rule_id: params[:rule_id]}).where.not(id: current_user.id)
    @standby = Standby.new
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

  def execute_create #ルール実行htmlから申請、待機テーブルへの登録までのアクション
    @community = Community.find(params[:community_id])
    @rule = Rule.find(params[:rule_id])
    userIds = params[:standby][:executed_user_id]
    detail = params[:standby][:detail]
    userIds.each do |user_id|
      standby = Standby.new(standby_params)
      standby.executing_user_id = current_user.id
      standby.executed_user_id = user_id
      standby.detail = detail
      standby.community_id = @community.id
      standby.rule_id = @rule.id
      standby.content = @rule.content
      standby.point = @rule.point
      standby.action_type = 'rule'
      standby.save!
    end
    redirect_to community_rules_path(@community.id)
  end

  def receive #ルール実行申請を受けての承認/否認のアクション(notificationアクションが実装できたら移行)
    @user = current_user
    @standbyRules = Standby.where(action_type: 'rule', executed_user_id: current_user.id, checked: false).order(created_at: :asc) #自分に送られたルール実行
    @standbyPenalties = Standby.where(action_type: 'penalty', executed_user_id: current_user.id, checked: false).order(created_at: :asc) #自分に送られたペナルティ承認依頼
    @unacceptedUsers = CommunityUser.joins(:community).where(status: 0).where(communities: {owner_id: current_user.id}) #自分に送られたコミュティ参加依頼受信
  end

  def approval #ルール承認
    standby = Standby.find(params[:id])
    @community_user = CommunityUser.find_by(user_id: standby.executed_user_id, community_id: standby.community_id)#whereは条件にあっているデータを複数とってくる。今回は1つのデータを取る前提なのでfind_byを利用。
    @community_user.point += standby.point
    @community_user.save
    standby.checked = true #true=確認済み。今後ユーザーが受けてきたルールのカウントをする際には、trueの数をカウントすればいい。
    standby.approval = true
    standby.save
    redirect_to receive_path
  end

  def denial #ルール否認
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

  def rule_user_params
    params.require(:rule_user).permit(:rule_id, :user_id)
  end

  def standby_params
    params.require(:standby).permit(:executing_user_id, :executed_user_id, :community_id, :rule_id).merge(executing_user_id: current_user.id)
  end

  def record_params
    params.require(:record).permit(:community_id,:motto_id, :rule_id, :penalty_id, :privilege_id, :content, :point, :version ,:action_type, :updating_user_id, :user_id, :genre) #ストロングパラメータを使わずに保存する項目については、ここに記載しなくてもOK。今回の場合action_typeなどはなくてOK？
  end

  def user_params
    params.require(:user).permit(:name, :body, :point)
  end

  def community_user
    community =  Community.find(params[:community_id])
    belongedUser = CommunityUser.find_by(community_id: community.id, user_id: current_user.id)
    unless community.community_users.exists?(user_id: current_user.id) && belongedUser.status == 1
      redirect_to top_path
    end
  end

end
