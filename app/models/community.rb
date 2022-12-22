class Community < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :mottos, dependent: :destroy
  has_many :standbys, dependent: :destroy
  has_many :privileges, dependent: :destroy
  has_many :penalties, dependent: :destroy
  has_many :records, dependent: :destroy

  def self.search(search)
    if search != ""
      Community.where('community_name LIKE(?)', "%#{search}%")
    else
      Community.all
    end
  end

end
