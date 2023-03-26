class Privilege < ApplicationRecord
  belongs_to :community
  belongs_to :user
  has_many :standbies
  has_many :records
end
