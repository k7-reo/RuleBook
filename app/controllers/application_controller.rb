class ApplicationController < ActionController::Base

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :common_action

  def after_sign_in_path_for(resoure) #ログイン後のリダイレクト先をtophtmlに変更
    top_path
  end

  def common_action
    if user_signed_in?
      @standbyRules = Standby.where(action_type: 'rule', executed_user_id: current_user.id, checked: false).order(created_at: :asc) #自分に送られたルール実行
      @standbyPenalties = Standby.where(action_type: 'penalty', executed_user_id: current_user.id, checked: false).order(created_at: :asc) #自分に送られたペナルティ承認依頼
      @unacceptedUsers = CommunityUser.joins(:community).where(status: 0).where(communities: {owner_id: current_user.id}) #自分に送られたコミュティ参加依頼受信
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

end
