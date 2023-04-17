class RemoveCommunityImageIdFromCommunities < ActiveRecord::Migration[6.1]
  def change
    remove_column :communities, :community_image_id
  end
end
