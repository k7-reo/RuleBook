class AddMonthlyPointToCommunityUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :community_users, :monthly_point, :integer, default: 0
  end
end
