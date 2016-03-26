require 'rubygems' if RUBY_VERSION < '1.9'
require 'rest_client'
require 'fileutils'

DATA_DIR = 'teratails'.freeze
URL = 'https://teratail.com/api/v1/questions'.freeze
MAX_COUNT = 300 # 300 5

start_page = 0 # 0 300, 305 ...

headers = {
  Authorization: "Bearer #{ENV['TERATAIL']}"
}

(1..MAX_COUNT).each do |count|
  page = start_page + count
  response = RestClient.get("#{URL}?limit=100&page=#{page}", headers)
  res = JSON.parse(response)
  p "#-------- getting page:#{page}/#{res['meta']['total_page']}"
  res['questions'].each do |q|
    id = Integer(q['id'])
    p id
    dir = "#{DATA_DIR}/#{format('%06d', id / 100)}"
    FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)
    file_name = "#{dir}/#{format('%06d', id)}.json"
    open(file_name, 'w') do |io|
      JSON.dump(q, io)
    end
  end
end
