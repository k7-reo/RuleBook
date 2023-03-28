class RemoveMottoIdFromStandbies < ActiveRecord::Migration[5.2]
  def change
    remove_column :standbies, :motto_id, :integer
  end
end
