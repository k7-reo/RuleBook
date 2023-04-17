class Community < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users
  has_many :rules, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :mottos, dependent: :destroy
  has_many :standbies, dependent: :destroy
  has_many :privileges, dependent: :destroy
  has_many :penalties, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_one_attached :community_image #ActiveStrageによる画像保存機能
  validates :community_name, presence: { message: "コミュニティ名が登録されていません。" }

  def self.search(search)
    if search != ""
      Community.where('id LIKE(?)', "%#{search}%")
    end
  end

end
