class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  #アソシエーション
  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users
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
  #アイコン画像添付
  attachment :profile_image
end
