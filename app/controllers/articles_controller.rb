class ArticlesController < ApplicationController

  def _goal_articles
  end

  def _meeting_articles
  end

  def _motto_articles
  end

  def _privilege_penalty_articles
  end

  def _rule_articles
  end

  def index
    @community = Community.find(params[:community_id])
    @currentUser = CommunityUser.find_by(user_id: current_user.id, community_id: params[:community_id]) #community-info表示に利用
  end

end
