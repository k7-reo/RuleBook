class Meeting < ApplicationRecord
  belongs_to :community
  has_many :meeting_users, dependent: :destroy #meetingが消えたら対象となるmeeting_userレコードも消える
  has_many :users, through: :meeting_users
end
