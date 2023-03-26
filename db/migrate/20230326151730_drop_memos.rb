class DropMemos < ActiveRecord::Migration[5.2]
  def change
    drop_table "memos" do
    end
  end
end
