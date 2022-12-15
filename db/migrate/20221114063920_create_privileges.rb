class CreatePrivileges < ActiveRecord::Migration[5.2]
  def change
    create_table :privileges do |t|
      t.text :content
      t.integer :point
      t.integer :community_id
      t.integer :user_id
      t.timestamps
    end
  end
end
