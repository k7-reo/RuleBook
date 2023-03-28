class AddContentsToStandbies < ActiveRecord::Migration[5.2]
  def change
    add_column :standbies, :content, :string
  end
end
