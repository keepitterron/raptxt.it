# encoding: utf-8
require 'sinatra/base'

module Raptxt	
	class Admin < Sinatra::Base

		configure do
			disable :reload
			set :raise_errors => true
			set :public, File.join(File.dirname(__FILE__),'public')
		  enable :sessions
		  use Rack::Flash
		end

		helpers do
		  require File.join( File.expand_path(File.dirname(__FILE__)), 'helpers' )
		end
	
		get '/' do
			'panel'
		end
		get '/whereami' do
			'panel'
		end
		not_found do
			@title = '404 | not found - raptxt.it'
			haml :notfound
		end
	end
end