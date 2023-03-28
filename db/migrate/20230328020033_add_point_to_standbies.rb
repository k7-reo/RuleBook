class AddPointToStandbies < ActiveRecord::Migration[5.2]
  def change
    add_column :standbies, :point, :integar
  end
end
