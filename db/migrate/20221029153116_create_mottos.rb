class CreateMottos < ActiveRecord::Migration[5.2]
  def change
    create_table :mottos do |t|
      t.text :content
      t.integer :community_id
      t.integer :user_id
      t.timestamps
    end
  end
end
