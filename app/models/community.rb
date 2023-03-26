class Community < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :golas, dependent: :destroy
  has_many :mottos, dependent: :destroy
  has_many :standbies, dependent: :destroy
  has_many :privileges, dependent: :destroy
  has_many :penalties, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :meetings, dependent: :destroy
  #背景画像
  attachment :community_image

  def self.search(search)
    if search != ""
      Community.where('community_name LIKE(?)', "%#{search}%")
    else
      Community.all
    end
  end

end
