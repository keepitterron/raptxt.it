# encoding: utf-8
require 'sinatra/base'

module Raptxt	
	class Core < Sinatra::Base

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
			@is_home = true
			@albums = Album.latest
			@songs = Song.latest
			haml :index
		end
		
		get '/add_album/?' do
			@a = Album.new
			haml :add_album
		end
		post '/add_album/?' do
			begin
			@a = Album.create params[:album]
			redirect @a.url
			rescue
			@a = Album.load params[:album]
				@error = $!
			end
			haml :add_album
		end
		get '/add_testo/?' do
		end
		
		get '/album/:ltr?' do
			@is_list = true
			@albums = Album.list params[:ltr]
			haml :list_albums
		end
		get '/album/:artist/:slug' do
			@is_list = true
			id = params[:slug].match(/(\d+).html$/)[1].to_i
			@album = Album[id]
			redirect @album.url, 301 if '/album/'+params[:artist]+'/'+params[:slug] != @album.url
			@title = "#{@album.title} - #{@album.artist} | #{$settings.title}"
			404 unless @album
			haml :album
		end
		get '/testi/:ltr?' do
			params[:ltr] ||= 'a'
			pass if params[:ltr].length > 1
			@is_list = true
			@songs = Song.list params[:ltr]
			haml :list_testi
		end
		get '/testi/:artist' do
			@is_list = true
			@songs = Song.by_artist CGI::unescape(params[:a])
			haml :songs_by_artist
		end
		get '/testi/:artist/:slug' do
			@is_list = true
			id = params[:slug].match(/(\d+).html$/)[1].to_i
			@song = Song[id]
			redirect @song.url, 301 if '/testi/'+params[:artist]+'/'+params[:slug] != @song.url
			@title = "#{@song.title} - #{@song.artist} | #{$settings.title}"
			404 unless @song
			haml :song
		end
		get '/artisti/:ltr?' do
			@is_list = true
			@artists = Song.artists params[:ltr]
			haml :list_artists
		end
		not_found do
			@title = '404 | not found - raptxt.it'
			haml :notfound
		end
	end
end