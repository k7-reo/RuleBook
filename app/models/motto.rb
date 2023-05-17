class Motto < ApplicationRecord
  belongs_to :community
  belongs_to :user
  has_many :standbies
  has_many :records

  validates :content, presence: { message: "スローガンを入力してください。" }
end
