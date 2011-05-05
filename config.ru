require 'rubygems'
require File.join( File.expand_path(File.dirname(__FILE__)), 'config' )
require File.join(File.dirname(__FILE__), 'core.rb')

#map "/" do
	run Raptxt::Core
#end
#map "/blog" do
#	run Raptxt::Blog
#end