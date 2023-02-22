class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :community_name
      t.text :introduction
      t.integer :owner_id
      #t.text :manual ※migrationファイル2023020921318にて追加
      #t.string :genre ※igrationファイル20230221204210にて追加
      t.timestamps
    end
  end
end
