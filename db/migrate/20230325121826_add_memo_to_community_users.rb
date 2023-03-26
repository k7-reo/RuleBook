class AddMemoToCommunityUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :community_users, :memo, :text
  end
end
