class AddDetailToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :goal_id, :integer
  end
end
