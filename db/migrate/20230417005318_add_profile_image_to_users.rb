class AddProfileImageToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :profile_image, :string # ユーザーモデルにavatarカラムを追加
    add_column :users, :profile_image_metadata, :text # ユーザーモデルにavatar_metadataカラムを追加
  end
end
