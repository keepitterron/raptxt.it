class Album < Sequel::Model
	set_dataset :album
  one_to_many :songs

	set_schema do
		primary_key :album_id
		String 		:title
		String 		:artist
		String 		:label
		Integer					:year
		String 		:username
		String 		:site_url
		String 		:cover
		Text				:tracklist		
    Date 		:date
    Float				:voto
    Integer					:voti
  end
  
  unless table_exists?
    create_table
  end
  
  def self.search(q)
    value = "%#{q}%"
    filter(:title.ilike(value)).order(:date_created.desc)
  end
  
  def self.latest
  	exclude(:cover => ['noimage.png', '']).order(:date.desc).limit(12)
  end
  
  def slug
  	title.urlize + '_' + album_id.to_s + '.html'
  end
  def url
  	'/album/' + artist.urlize + '/' + title.urlize + '_' + album_id.to_s + '.html'
  end
  
  def link_cover
		"http://www.raptxt.it/img/image/#{cover}"
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