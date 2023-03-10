class AddCommunityImageIdToCommunities < ActiveRecord::Migration[5.2]
  def change
    add_column :communities, :community_image_id, :string
  end
end
