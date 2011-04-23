class String
  def ucwords
    self.split(' ').select {|w| w.capitalize! || w }.join(' ');
  end
end

def partial(view)
  haml :"_#{view}", :layout => false
end

def go_home
  redirect '/'
end

def env
  request['ENV']
end

def host
  "http://#{env['HTTP_HOST']}"
end

def path
  "#{host}#{env['REQUEST_PATH']}"
end

def to_link(title)
  title.gsub(' ', '-').urlize
end

def style
	'/style.css'
end

def simple_format(text)
  text = '' if text.nil?
  start_tag = '<p>'
  text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
  text.gsub!(/\n\n+/, "<br /><br />")  # 2+ newline  -> paragraph
  text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
  text.insert 0, start_tag
  text.concat("</p>")
end

def cgi_escape(text)
CGI::escape text
end

def linkify(text)

	generic_URL_regexp = Regexp.new( '(^|[\n ])([\w]+?://[\w]+[^ \"\n\r\t<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
	starts_with_www_regexp = Regexp.new( '(^|[\n ])((www)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
	starts_with_ftp_regexp = Regexp.new( '(^|[\n ])((ftp)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
	email_regexp = Regexp.new( '(^|[\n ])([a-z0-9&\-_\.]+?)@([\w\-]+\.([\w\-\.]+\.)*[\w]+)', Regexp::IGNORECASE )

  s = text.to_s
  s.gsub!( generic_URL_regexp, '\1<a href="\2">\2</a>' )
  s.gsub!( starts_with_www_regexp, '\1<a href="http://\2">\2</a>' )
  s.gsub!( starts_with_ftp_regexp, '\1<a href="ftp://\2">\2</a>' )
  s.gsub!( email_regexp, '\1<a href="mailto:\2@\3">\2@\3</a>' )
  s
end

def parse_song_by_artist(name)
	dataset = DB["SELECT song.title, song.artist, featuring, song_id, song.album_id, track, album.title as album, album.artist as artista, cover  FROM song JOIN album USING (album_id) WHERE album.artist = '#{name}' ORDER BY album.date, disc, track, song.title"]
	albums = {}
	dataset.each do |a|
		albums[a[:album_id]] ||= Array.new
		albums[a[:album_id]] << a
	end
	albums
	
end