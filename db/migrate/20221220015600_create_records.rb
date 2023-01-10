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
      t.integer :updating_user_id #更新ユーザー
      t.integer :version, null: false #1→作成、2以降→編集、0→削除
      t.string :action_type, default: '', null: false #mottoかruleかpenaltyかprivilegeか
      #t.integer :user_id 作成ユーザー※migrate20221227054946にて追加済。
      #t.string :genre 作成ユーザー※migrate20221227054946にて追加済。
      t.timestamps
    end
  end
end
