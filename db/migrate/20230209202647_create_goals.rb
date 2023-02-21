class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.integer :community_id #どのコミュニティのゴールか
      t.integer :user_id #作成ユーザー
      t.text    :content
      t.datetime   :deadline, optional: true
      t.timestamps
    end
  end
end
