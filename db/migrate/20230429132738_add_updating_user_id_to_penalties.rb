class AddUpdatingUserIdToPenalties < ActiveRecord::Migration[6.1]
  def change
    add_column :penalties, :updating_user_id, :integer
  end
end
