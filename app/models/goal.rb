class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :content, presence: { message: "ゴールを入力してください。" }

end
