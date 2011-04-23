class Song < Sequel::Model
	set_dataset :song  
  many_to_one :album
  
  set_schema do
    primary_key :song_id
    foreign_key	:album_id
    varchar :title
    varchar :album
    varchar :artist
    varchar :featuring
    varchar :producer
    text		:lyrics
    int	:track
    int	:disc
    int :ups, :null=>false,:default=>0
    int :downs, :null=>false,:default=>0
    int :m_hits
  end
  
  unless table_exists?
    create_table
  end
  
  def self.latest
  	order(:m_hits.desc).limit(20)
  end
  def slug
  	title.urlize + '_' + song_id.to_s + '.html'
  end
  def url
  	'/testi/' + artist.urlize + '/' + title.urlize + '_' + song_id.to_s + '.html'
  end
  def self.list(ltr)
  	ltr ||= 'a'
  	if ltr.match(/[0-9]/)
  		filter(:title.ilike(/^[0-9]/, /^[\\?\'-\.<>]/)).order(:title.asc)
  	else
    	filter(:title.ilike("#{ltr}%")).order(:title.asc)
    end
  end
end