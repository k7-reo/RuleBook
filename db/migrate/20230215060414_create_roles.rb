class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :content
      t.integer :user_id
      t.integer :community_id
      t.timestamps
    end
  end
end
