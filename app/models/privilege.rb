class Privilege < ApplicationRecord
  belongs_to :community
  belongs_to :creating_user, class_name: 'User', foreign_key: :user_id, optional: true
  belongs_to :updating_user, class_name: 'User', foreign_key: :updating_user_id, optional: true
  has_many :standbies
  has_many :records

  validates :content, presence: { message: "内容を入力してください。" }
  validates :point, presence: { message: "ポイントを入力してください。" }
  validates :point, numericality: { only_integer: true, greater_than: 1, message: '1以上の半角数値を入力してください。' }, if: -> { point.present? }  
end
