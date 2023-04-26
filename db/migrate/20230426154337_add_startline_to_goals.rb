class AddStartlineToGoals < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :startline, :datetime
  end
end
