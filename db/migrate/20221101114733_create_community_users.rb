class CreateCommunityUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :community_users do |t|
      t.references  :user, foreign_key: true
      t.references  :community, foreign_key: true
      t.integer :point, default: 0 #community毎にuserのポイントを別で管理するため
      t.integer :status, default: 0 #0グループ参加申請中、1グループ参加承認済
      t.timestamps
    end
  end
end
