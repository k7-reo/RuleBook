class RuleUser < ApplicationRecord
  belongs_to :user
  belongs_to :rule
end
