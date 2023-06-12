# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/environment") #Rails.root(Railsメソッド)を使用するために必要
rails_env = ENV['RAILS_ENV'] || :development #cronを実行する環境変数(:development, :product, :test)
set :environment, rails_env #cronを実行する環境変数をセット
set :output, {
  error: "#{Rails.root}/log/cron_error.log",
  standard: "#{Rails.root}/log/crontab.log"
} #cronのログ出力用ファイル
env :PATH, ENV['PATH'] #アプリを開発している環境で実行できるように指定する。これがないと既存埋め込みの2.6で実行しようとして現在の3.1と齟齬があり実行できない。

every 1.month, at: 'start of the month' do
  rake "users_point:total_monthly_point"
end

#every '21 15 24 * *' do #この形式の時間設定だとなぜか動かない。
#  rake "sample_task:reo_point_add"
#end

#every '* * * * *' do
#  rake "sample_task:reo_point_add"
#end