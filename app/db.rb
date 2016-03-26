# See http://planetruby.github.io/gems/rails-erd.html

require 'active_record'
require 'yaml'
require 'erb'
require './app/models/question'
require './app/models/user'
require './app/models/tag'
require 'rails_erd/diagram'

# 開発用DB接続パラメータ読み込み, 接続する
db_conf = YAML.load(ERB.new(File.read('./config/database.yml') ).result)
env = 'development'||ENV['ENV']
ActiveRecord::Base.establish_connection(db_conf[env])

def show_models
  models = ActiveRecord::Base.descendants

  puts " #{models.size} models:"
  models.each do |model|
    puts model.name.to_s
    puts '  columns:'
    model.columns.each do |column|
      puts "    #{column.name} #{column.sql_type}"
    end

    puts '  assocs:'
    model.reflect_on_all_associations.each do |assoc|
      puts "    #{assoc.macro} #{assoc.name}"
    end
  end
end

class YumlDiagram < RailsERD::Diagram

  setup do
    @edges = []
  end

  each_relationship do |relationship|
    line = if relationship.indirect? then "-.-" else "-" end

    arrow = case
    when relationship.one_to_one?   then "1#{line}1>"
    when relationship.one_to_many?  then "1#{line}*>"
    when relationship.many_to_many? then "*#{line}*>"
    end

    @edges << "[#{relationship.source}] #{arrow} [#{relationship.destination}]"
  end

  save do
    puts @edges.join("\n")
  end
end

domain = RailsERD::Domain.generate

# p domain.entities         ## dump all entities (models)
# p domain.relationships    ## dump all relationships (assocs)

## Generate diagram
diagram = YumlDiagram.new(domain)
diagram.generate   ## step 1 - generate
diagram.save       ## step 2 - save

show_models
