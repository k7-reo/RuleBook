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
  validate :validate_positive_point, on: :create_positive #create_positiveアクションのみでバリデーション
  validate :validate_negative_point, on: :create_negative #create_negativeアクションのみでバリデーション
  validate :validates_point_abs, on: :update #updateアクションのみでバリデーション
  validates :genre, presence: { message: "ジャンルを選択してください。" }
  validates :user_ids, presence: { message: "対象メンバーを選択してください。" }

  def validate_positive_point
    if point.present? && point.to_i < 1
      errors.add(:point, '1以上の半角数値を入力してください。')
    end
  end

  def validate_negative_point
    if point.present? && point.to_i > -1
      errors.add(:point, '-1以下の半角数値を入力してください。')
    end
  end

  def validates_point_abs
    if point.present? && point.abs < 1
      errors.add(:point, '0以外の半角数値を入力してください。')
    end
  end

end
