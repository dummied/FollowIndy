class Source < ActiveRecord::Base
  has_many :things
  has_many :feeds
  
  after_create :set_process_time
  
  PROCESSING_SERVER_ROOT = "http://followindy-updater"
  
  def to_param
    slug
  end
  
  def processing_server
    if id <= 8
      PROCESSING_SERVER_ROOT + id + ".appspot.com"
    else
      PROCESSING_SERVER_ROOT + (id.divmod(8)[1] + 1).to_s + ".appspot.com"
    end
  end
  
  def set_process_time
    self.process_next = Time.now + 10.minutes
    self.save!
  end
  
  def self.needs_run
    needed = self.where(:process_next.lt => Time.now)
    needed.each do |need|
      need.process
    end
  end
  
  def process
    self.feeds.each do |p|
      system("curl #{self.processing_server}/feeds/#{CGI::escape(p.url)}")
    end
    self.set_process_time
  end
end
