class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :name, default: '定例会' #定例会の名前
      t.integer :community_id
      t.integer :user_id #主催者
      t.text :content #メモ
      t.string :todo #次回までにやること
      t.string :agenda #今回話す内容
      t.string :next_agenda #次回話す内容
      t.datetime :date #開催日
      t.datetime :next_date #次回開催予定日
      t.integer :status, default: 0 #未開催0、開催中1、終了2
      #t.string :next_name ※20230301044435にて追加。
      #参加者は中間テーブルmeeting_userを作成。
      t.timestamps
    end
  end
end
