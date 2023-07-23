class RemoveCommunityImageIdFromCommunities < ActiveRecord::Migration[6.1]
  def up
    remove_column :communities, :community_image_id
  end

  def down
    add_column :communities, :community_image_id, :integer
  end
end
