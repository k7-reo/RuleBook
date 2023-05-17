class Role < ApplicationRecord
  belongs_to :user

  validates :content, presence: { message: "内容を入力してください。" }
end
