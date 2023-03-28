class AddApprovalToStandbies < ActiveRecord::Migration[5.2]
  def change
    add_column :standbies, :approval, :boolean, default: false, null: false
  end
end
