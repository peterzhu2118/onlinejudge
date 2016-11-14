# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

require 'console'

mutex = Mutex.new
Rails.cache.write(:mutex, mutex)

