module FeedDetectHelpers
  def self.included(base)
    base.class_eval do
      include FeedDetectHelpers::Helpers
    end
  end
  
  module Helpers
   
    def feed_tag
       if defined?(@feed_url)
         if @feed_url.include?("atom")
           type = "atom"
         else 
           type = "rss"
         end
         auto_discovery_link_tag(type.to_sym, @feed_url)
       end
    end  
  
  end
  
end