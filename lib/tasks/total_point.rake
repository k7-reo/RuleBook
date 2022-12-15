namespace :users_point do
  desc 'CommunityUserのpointをmonthly_pointに反映させる。wheneverと組み合わせて毎月末定期実行。'
  task total_monthly_point: :environment do
    users = CommunityUser.all
    users.each do |user|
      user.monthly_point += user.point #前月の残monthly_pointにpointを加算
      user.point = 0 #pointを0にリセット
      user.save
    end
  end
end
