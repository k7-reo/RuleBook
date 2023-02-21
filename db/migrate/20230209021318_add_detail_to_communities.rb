class AddDetailToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :manual, :text
  end
end
