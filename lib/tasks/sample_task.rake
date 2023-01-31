namespace :sample_task do
  desc "reo君に200ポイント追加"
  task reo_point_add: :environment do
    reo = CommunityUser.find_by(id: 1)
    reo.point += 200
    reo.save
  end
end
# 1/10 22:04時点で400point