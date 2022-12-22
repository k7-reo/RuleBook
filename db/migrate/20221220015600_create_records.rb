class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :community_id
      t.integer :motto_id, optional: true
      t.integer :rule_id, optional: true
      t.integer :penalty_id, optional: true
      t.integer :privilege_id, optional: true
      t.text :content
      t.integer :point, optional: true
      t.integer :updating_user_id
      t.integer :version, null: false #1→作成しました。2以降編集しました。0削除しました。
      t.string :action_type, default: '', null: false #mottoかruleかpenaltyかprivilegeか
      t.timestamps
    end
  end
end
