class AddDetailToStandbies < ActiveRecord::Migration[5.2]
  def change
    add_column :standbies, :detail, :string
  end
end
