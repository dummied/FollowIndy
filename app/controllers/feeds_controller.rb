
class FeedsController < ApplicationController
  def show
    feed = Feed.find(params[:id])
    c = Curl::Easy.perform(feed.url) do |curl|
      curl.follow_location = true
    end
    render :xml => c.body_str
  end
  
  def indystar_feed_maker
    http = RubyTubesday.new
    @feed = http.get("http://www.indystar.com/apps/pbcs.dll/section?Category=XMLFEED&template=rss&mime=XML").gsub("<br>", "<br />").gsub("&amp;template=xml", "")
    render :xml => @feed
      
  end
end
