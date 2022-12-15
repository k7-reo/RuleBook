class Motto < ApplicationRecord
  belongs_to :community
  belongs_to :user
  has_many :standbys
end
