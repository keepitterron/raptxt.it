class Song < Sequel::Model(:song)
	many_to_one :album
  attr_accessor :album_title, :album_artist, :album_cover
  
  def after_initialize
  	#self.forced_encoding
  end
  
  def slug
  	title.urlize + '_' + song_id.to_s + '.html'
  end
  def url
  	'/testi/' + artist.urlize + '/' + title.urlize + '_' + song_id.to_s + '.html'
  end
  def album_url
  	'/album/' + album_artist.urlize + '/' + album_title.urlize + '_' + album_id.to_s + '.html' unless album_artist.nil?
  end
  def cover
  	'/img/image/'+album_cover unless album_cover.nil?
  end

  def self.artists(ltr)
  	ltr ||= 'a'
  	if ltr.match(/[0-9]/)
  		@where = " WHERE song.artist REGEXP '/^[0-9]/, /^[\\?\'-\.<>]/' "
  	else
  		@where = " WHERE song.artist LIKE '#{ltr}%' "
  	end
  	@dataset = DB["SELECT song.artist AS song_artist, album.title, album.artist as album_artist, song.song_id, song.album_id, cover FROM song JOIN album USING (album_id) #{@where} ORDER BY song.artist"]
  	@artists = {}
  	@dataset.each do |a|  		
  		@artists["#{a[:album_artist]}"] ||= {:name => a[:album_artist], :songs => 0, :albums => []}
  		@artists["#{a[:album_artist]}"][:songs] +=1
  		@artists["#{a[:album_artist]}"][:albums] << a[:album_id] unless @artists["#{a[:album_artist]}"][:albums].include? a[:album_id]
  	end
  	@artists
  end
	
	def self.by_artist(name)
		@dataset = DB["SELECT song.title, song.artist, featuring, song_id, song.album_id, track, album.title as album_title, album.artist as album_artist, cover as album_cover  FROM song JOIN album USING (album_id) WHERE album.artist = '#{name}' ORDER BY album.date, disc, track, song.title"]

		@albums = {}
		@ids = []
		@dataset.each do |a|
			s = Song.load(a)
			s.album_title = a[:album_title]
			s.album_artist = a[:album_artist]
			s.album_cover = a[:album_cover]
			@albums[a[:album_id]] ||= Array.new
			@albums[a[:album_id]] << s
			@ids << s.song_id
		end
		
		@dataset = DB["SELECT song.title, song.artist, featuring, song_id, song.album_id, track, album.title as album_title, album.artist as album_artist, cover as album_cover  FROM song JOIN album USING (album_id)
		 WHERE (song.artist = '#{name}' OR song.featuring LIKE '%#{name}%')
		 ORDER BY album.title, disc, track, song.title"]
		@dataset.each do |a|
			next if @ids.include? a[:song_id]
			s = Song.load(a)
			s.album_title = a[:album_title]
			s.album_artist = a[:album_artist]
			s.album_cover = a[:album_cover]
			@albums[a[:album_id]] ||= Array.new
			@albums[a[:album_id]] << s
			@ids << s.song_id
		end		

		@albums
	end
	def self.by_title(ltr)
  	ltr ||= 'a'
  	if ltr.match(/[0-9]/)
  		@where = ' WHERE song.title REGEXP \'^[0-9]\' OR song.title REGEXP \'^[\\?\\\'-\.<>]\''
  	else
  		@where = " WHERE song.title LIKE '#{ltr}%' "
  	end
  	@dataset = DB["SELECT song.title, song.artist, album.title as album_title, song.track, song.song_id, song.album_id, song.featuring, song.lyrics FROM song JOIN album USING (album_id) #{@where} ORDER BY song.title"]
  	@titles = []
  	@dataset.each do |title|
  		s = Song.load(title)
  		s.album_title = title[:album_title]
  		@titles << s
  	end
  	@titles
	end
	def self.latest
		@dataset = DB["SELECT song.title, song.artist, featuring, song_id, song.album_id, track, album.title as album_title, album.artist as album_artist, cover as album_cover, m_hits FROM song JOIN album USING (album_id) ORDER BY m_hits DESC LIMIT 20"]
		
		@albums = Array.new
		@dataset.each do |a|
			s = Song.load(a)
			s.album_title = a[:album_title]
			s.album_artist = a[:album_artist]
			s.album_cover = a[:album_cover]
			@albums << s
		end
		@albums
	end
  
end