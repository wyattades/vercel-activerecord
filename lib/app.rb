require 'find'

puts `ls -la /usr/lib64`
puts `ls -la ./local-lib`

# def find_file(filename)
#   begin
#     Find.find('/') { |path| return path if File.basename(path) == filename }
#   rescue StandardError => err
#     puts 'FIND ERROR:', err
#     nil
#   end
# end

#/vercel/workspace0
#/var/task

ENV['LD_LIBRARY_PATH'] = "#{ENV['LD_LIBRARY_PATH']}:/var/task/local-lib"

puts(
  # pwd: Dir.pwd,
  ld: ENV['LD_LIBRARY_PATH'],
  # libpq: libpq_path,
  # sh_path: sh_path,
)

puts "foobar contents: #{
       (
         begin
           File.read('./local-lib/foobar.txt')
         rescue StandardError
           nil
         end
       )
     }"

require 'active_record'
require 'uri'

ActiveRecord::Base.establish_connection ENV['DATABASE_URL']

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

# Define the models
class Show < ApplicationRecord
  has_many :episodes, inverse_of: :show
end

class Episode < ApplicationRecord
  belongs_to :show, inverse_of: :episodes, required: true
end
