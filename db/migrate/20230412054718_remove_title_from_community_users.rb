class RemoveTitleFromCommunityUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :community_users, :memo, :text
  end
end
