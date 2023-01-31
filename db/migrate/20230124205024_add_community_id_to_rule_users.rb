class AddCommunityIdToRuleUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :rule_users, :community_id, :integer
  end
end
