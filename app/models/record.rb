class Record < ApplicationRecord
  belongs_to :community
  belongs_to :rule, optional: true
  belongs_to :motto, optional: true
  belongs_to :penalty, optional: true
  belongs_to :privilege, optional: true
  belongs_to :user
end

#「変更履歴」に過去1ヶ月に絞って表示させる→wheneverで毎日過去30以前のデータを削除する定期実行。