class AddCommunityImageToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :community_image, :string # ユーザーモデルにavatarカラムを追加
    add_column :communities, :community_image_metadata, :text # ユーザーモデルにavatar_metadataカラムを追加
  
  end
end
