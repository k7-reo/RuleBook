class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable and :validatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable
  #アソシエーション
  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users
  has_many :goals
  has_many :rule_users
  has_many :rules, through: :rule_users
  has_many :rules
  has_many :mottos
  has_many :standbies
  has_many :penalties
  has_many :privileges
  has_many :records
  has_many :roles, dependent: :destroy
  has_many :meeting_users
  has_many :meetings, through: :meeting_users
  has_one_attached :profile_image #ActiveStrageによる画像保存機能

  VALID_PASSWORD_REGEX = /\A[A-Za-z0-9]+\z/ # 正規表現パターンを定義する（例: 半角英数字のみ）

  validates :name, presence: { message: "ユーザーネームを入力してください。" }
  validates :email, presence: { message: "メールアドレスを入力してください。" }
  validates :password, presence: { message: "パスワードを入力してください。"}, on: :create
  validates :password, length: { minimum: 6, message: '6文字以上のパスワードを登録してください。'} , if: -> { password.present? }
  validates :password, format: { with: VALID_PASSWORD_REGEX, message: '半角英数字のみで登録してください。'} , if: -> { password.present? }
  validates :password_confirmation, presence: { message: "パスワード再確認を入力してください。"}, on: :create
  validates_confirmation_of :password, message: 'パスワードが一致していません。'
end
