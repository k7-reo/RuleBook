class Standby < ApplicationRecord
  belongs_to :community
  belongs_to :rule, class_name: 'Rule', foreign_key: :rule_id, optional: true
  belongs_to :motto, optional: true
  belongs_to :penalty, optional: true
  belongs_to :privilege, optional: true
  belongs_to :executing_user, class_name: 'User', foreign_key: :executing_user_id
  belongs_to :executed_user, class_name: 'User', foreign_key: :executed_user_id
  #belongs_to :{任意の名前}, class_name: 'リレーションするモデルのクラス名', foreign_key: :{リレーションするカラム名}。
  #複数Userのuser_idとリレーションを貼っている為リレーションの名前を別にする必要がある。

  validates :executed_user_id, presence: { message: "対象メンバーを選択してください。" }

end
