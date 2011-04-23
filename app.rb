# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/cache'
require 'haml'
require 'cgi'
require File.join( File.expand_path(File.dirname(__FILE__)), 'config' )

set :production, true
set :caching_enabled, true

get '/' do
	@is_home = true
	@albums = Album.latest
	@songs = Song.latest
	haml :index
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
	@songs = parse_song_by_artist CGI::unescape(params[:a])
	#@songs = Song.filter(:artist.ilike(params[:artist]) | :featuring.ilike(params[:artist])).order(:album_id.asc(), :title.asc())
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
not_found do
	@title = '404 | not found - raptxt.it'
	haml :notfound
end