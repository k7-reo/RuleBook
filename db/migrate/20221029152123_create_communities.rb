class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :community_name
      t.text :introduction
      t.integer :owner_id
      t.timestamps
    end
  end
end
