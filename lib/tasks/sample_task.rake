namespace :sample_task do
  desc "reo君に100ポイント追加"
  task reo_point_add: :environment do
    reo = CommunityUser.find_by(id: 8)
    reo.point += 100
    reo.save
  end
end
