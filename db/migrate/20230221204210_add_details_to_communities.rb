class AddDetailsToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :genre, :string
  end
end
