class AddUserToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :user_id, :integer #作成者
    add_column :records, :genre, :string, optional: true #ruleの際のgenre
  end
end
