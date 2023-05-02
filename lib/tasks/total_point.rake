namespace :users_point do
  desc 'CommunityUserのpointをmonthly_pointに反映させる。wheneverと組み合わせて毎月末定期実行。'
  task total_monthly_point: :environment do
    users = CommunityUser.all
    users.each do |user|
      if user.monthly_point < 0
        user.monthly_point = user.monthly_point * 1.5
        user.save
      end
      user.monthly_point += user.point #前月の残monthly_pointにpointを加算
      user.point = 0 #pointを0にリセット
      user.save
    end
  end
end
