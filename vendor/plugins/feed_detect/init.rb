require 'feed_detect' 

ActionController::MimeResponds::Responder.send(:include, FeedDetect)  
ActionView::Base.send(:include, FeedDetectHelpers)
