class CreateRuleUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rule_users do |t|
      t.references :rule, foreign_key: true
      t.references :user, foreign_key: true
      #t.integer :comunity_id ※20230124205024で追加
      t.timestamps
    end
  end
end
