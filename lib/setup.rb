require 'active_record'
require 'uri'
require 'dotenv/load'

ActiveRecord::Base.establish_connection ENV['DATABASE_URL']

# Define a minimal database schema
ActiveRecord::Schema.define do
  create_table :shows, if_not_exists: true do |t|
    t.string :name
  end

  create_table :episodes, if_not_exists: true do |t|
    t.string :name
    t.belongs_to :show, index: true
  end
end
