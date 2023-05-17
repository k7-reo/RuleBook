class Rule < ApplicationRecord
  has_many :rule_users, dependent: :destroy #ruleが消えたら、rule_userからも対象のruleが含まれるレコードが削除される。
  has_many :users, through: :rule_users
  belongs_to :community
  belongs_to :creating_user, class_name: 'User', foreign_key: :user_id, optional: true
  belongs_to :updating_user, class_name: 'User', foreign_key: :updating_user_id, optional: true
  has_many :standbies
  has_many :records

  validates :content, presence: { message: "内容を入力してください。" }
  validates :point, presence: { message: "ポイントを入力してください。" }
  validate :validate_point_abs
  validates :genre, presence: { message: "ジャンルを選択してください。" }
  validates :user_ids, presence: { message: "対象メンバーを選択してください。" }

  def validate_point_abs
    if point.present? && point.abs < 1
      errors.add(:point, '0以外の半角数値を入力してください。')
    end
  end

end
