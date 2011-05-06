require 'rubygems'
require File.join( File.expand_path(File.dirname(__FILE__)), 'config' )
require File.join(File.dirname(__FILE__), 'core.rb')
require File.join(File.dirname(__FILE__), 'admin.rb')

map "/" do
	run Raptxt::Core
end
map "/panel" do
	run Raptxt::Admin
end