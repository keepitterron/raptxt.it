require 'sequel'
require 'sequel/extensions/pagination'
require 'rack-flash'

#require_relative 'lib/datasync.rb'
require File.join( File.expand_path(File.dirname(__FILE__)), 'lib/extend_string.rb' )

# Database connection.
#DB = Sequel.connect 'sqlite://raptxt.db'
DB = Sequel.mysql 'raptxt', :user => 'root', :password => '', :host => '127.0.0.1', :socket => '/Applications/MEPP/tmp/mysql/mysql.sock'

# Sequel schema plugin.
Sequel::Model.plugin :schema
Sequel::MySQL.convert_invalid_date_time = nil

# Database models.
Dir['models/*.rb'].each { |model| require File.join( File.expand_path(File.dirname(__FILE__)), model ) }

# Sinatra configurations.
configure do
  enable :sessions
  use Rack::Flash
end

# Application helpers.
helpers do
  require File.join( File.expand_path(File.dirname(__FILE__)), 'helpers' )
end

# Blog configurations.
Settings = Struct.new(:title, :desc, :code, :feed, :footer, :tracker)
$settings = Settings.new('raptxt.it', 'solo testi hip hop italiani')

# Posts per page
PAGE_SIZE = 10