class Meeting < ApplicationRecord
  belongs_to :community
  has_many :meeting_users, dependent: :destroy #meetingが消えたら対象となるmeeting_userレコードも消える
  has_many :users, through: :meeting_users

  validates :name, presence: { message: "会議名を入力してください。" }
  validates :date, presence: { message: "予定日を入力してください。" }
  validates :user_ids, presence: { message: "参加者をチェックしてください。" }
end
