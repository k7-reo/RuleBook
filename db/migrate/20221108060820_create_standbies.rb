class CreateStandbies < ActiveRecord::Migration[5.2]
  def change
    create_table :standbies do |t|
      t.integer :community_id
      t.integer :motto_id, optional: true
      t.integer :rule_id, optional: true
      t.integer :penalty_id, optional: true
      t.integer :privilege_id, optional: true
      t.string :action_type, default: '', null: false #mottoかruleかpenaltyかprivilegeか
      t.integer :executing_user_id
      t.integer :executed_user_id
      t.boolean :checked, default: false, null: false #false→receiveに表示、true→ユーザーの承認or否認完了
      t.timestamps
      #t.string :detail ※migrationの20230203015432にて追加済み
    end
  end
end
