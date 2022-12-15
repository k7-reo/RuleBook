class AddUpdatingUserIdToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :updating_user_id, :integer, optional: true
  end
end
