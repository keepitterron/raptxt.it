require 'carrierwave'
class CoverUploader < CarrierWave::Uploader::Base
	permissions 0777
	def filename
		"nocover.png" if path.nil?
  	File.basename(path) unless path.nil?
	end 
	def root
		'../'
	end
	def store_dir
		'public/img/image'
	end
	def extension_white_list
		%w(jpg jpeg gif png)
	end
end
class Album < Sequel::Model(:album)
  one_to_many :songs, :order => "disc ASC, track ASC"
  plugin :validation_helpers
  mount_uploader :cover, CoverUploader

	def validate
		super
		validates_presence [:title, :artist, :year, :tracklist]
	end
	def before_create
		super
		self.date ||= Time.now
	end
	def after_create
		super
		notify_me
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
		"http://www.raptxt.it/img/image/#{cover.filename}"
		"/img/image/#{cover.filename}"
  end
  
  def self.list(ltr)
  	ltr ||= 'a'
  	if ltr.match(/[0-9]/)
  		filter(:title.ilike(/^[0-9]/, /^[\\?\'-\.<>]/)).order(:title.asc)
  	else
    	filter(:title.ilike("#{ltr}%")).order(:title.asc)
    end
  end
  
  def notify_me
		Pony.mail(
			:to => 'raptxt@raptxt.it',
			:from => 'raptxt@raptxt.it',
			:subject => "[raptxt.it - album] nuovo album: #{title} - #{artist}",
			:body => "#{title} - #{artist}: #{url}",
			:via => :smtp, 
			:via_options => {
	    :address              => 'smtp.gmail.com',
	    :port                 => '587',
	    :enable_starttls_auto => true,
	    :user_name            => '',
	    :password             => '',
	    :authentication       => :plain,
	    :domain               => "raptxt.it"
		})  
  end
  
end