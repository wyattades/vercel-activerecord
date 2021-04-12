require 'active_record'
require 'uri'
require 'json'
# require 'dotenv/load'

require_relative './rails_handler'

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
