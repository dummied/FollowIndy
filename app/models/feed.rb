class Feed < ActiveRecord::Base
  belongs_to :source
  
  PSHB = SuperfeedrPshb::SuperfeedrPshb.new("dummied", "ruiner", "http://followindy-updater.appspot.com")

  
  # after_create :subscribe
  # after_destroy :unsubscribe
  
  def subscribe
    # PSHB.subscribe("/api/superfeedr/receive_feeds/", "http://li182-172.members.linode.com/feeds/#{self.id}", "async")
    PSHB.subscribe("/api/superfeedr/receive_feeds/", self.url, "async")
  end
  
  def unsubscribe
    # PSHB.unsubscribe("/api/superfeedr/receive_feeds/", "http://li182-172.members.linode.com/feeds/#{self.id}", "async")
    PSHB.unsubscribe("/api/superfeedr/receive_feeds/", self.url, "async")
  end
end
