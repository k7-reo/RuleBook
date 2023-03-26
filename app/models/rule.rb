class Rule < ApplicationRecord
  has_many :rule_users, dependent: :destroy #ruleが消えたら、rule_userからも対象のruleが含まれるレコードが削除される。
  has_many :users, through: :rule_users
  belongs_to :community
  belongs_to :creating_user, class_name: 'User', foreign_key: :user_id, optional: true
  belongs_to :updating_user, class_name: 'User', foreign_key: :updating_user_id, optional: true
  has_many :standbies
  has_many :records
end
