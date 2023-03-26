class AddDetailsToGoals < ActiveRecord::Migration[5.2]
  def change
    add_column :goals, :achievement, :boolean, default: false, null: false
    add_column :goals, :status, :boolean, default: true, null: false
  end
end
