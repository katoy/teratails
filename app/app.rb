
require 'active_record'
require 'yaml'
require 'erb'
require './app/models/question'
require './app/models/user'
require './app/models/tag'

# 開発用DB接続パラメータ読み込み, 接続する
db_conf = YAML.load(ERB.new(File.read('./config/database.yml') ).result)
env = 'development'||ENV['ENV']
ActiveRecord::Base.establish_connection(db_conf[env])

STDOUT.sync = true

Tag.all.each do |t|
  qs = t.questions
  count = qs.count
  accepted_count = 0
  qs.each { |q| accepted_count += 1 if q.is_accepted }
  puts "#{t.name},#{accepted_count},#{count},#{format('%4.2f', 100.0 * accepted_count / count)}"
end
