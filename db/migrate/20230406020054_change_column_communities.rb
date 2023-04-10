class ChangeColumnCommunities < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:communities, :genre, from: nil, to: "夫婦・カップル")
  end
end
