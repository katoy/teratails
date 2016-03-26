
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

Dir.glob('teratails/**/*.json').each do |file|
  data = open(file) { |io| JSON.load(io) }
  att_user = data['user']
  att_tags = data['tags']
  id = data['id']
  printf "#{id} "

  user = nil
  if att_user
    user = User.find_by(display_name: att_user['display_name'])
    if user.nil?
      user = User.create!(att_user)
    else
      user.update_attributes!(att_user)
    end
  end

  tags = []
  att_tags.each do |tag|
    ar_tag = Tag.find_by(name: tag)
    ar_tag = Tag.create!(name: tag) if ar_tag.nil?
    tags << ar_tag
  end

  data.delete('user')
  data.delete('tags')

  question = Question.find_by(id: id)
  if question.nil?
    question = Question.create!(data)
    question.user = user
    question.tags = tags
    question.save!
  else
    question.user = user
    question.tags = tags
    question.update_attributes!(data)
  end
end

Question.all.each do |q|
  user_name = "退会済みユーザー"
  user_name = q.user.display_name if q.user
  tag_names = q.tags.map(&:name).join(', ')
  puts "#{q.id}:\t#{q.title} #{user_name}"
  puts "   tags: #{tag_names}"
end

User.all.each do |u|
  puts "#{u.display_name} #{u.score}"
end
Tag.all.each do |t|
  puts "#{t.name}"
end
