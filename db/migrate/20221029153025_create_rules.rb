class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.text :content
      t.integer :point
      t.string :genre
      t.integer :community_id
      t.integer :user_id
      t.timestamps
    end
  end
end
