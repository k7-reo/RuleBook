class CreateMeetingUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :meeting_users do |t|
      t.references :meeting, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :community_id
      t.timestamps
    end
  end
end
