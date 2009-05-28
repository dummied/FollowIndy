module WishFetch
   FEEDS = [
     "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=20000",
     "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=20613",
     "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=20016",
     "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=10004"
   ]

   def self.fetch
      last_article = Thing.find(:first, :conditions => "source = 'wish'", :order => "created_at DESC")
      FEEDS.each do |f|
        begin
        http = RubyTubesday.new
        feed = Hpricot.XML(http.get(f))
        items = (feed/"item")
        items = items.reject{|u| Time.parse((u/"pubDate").first.inner_html) < last_article.created_at} unless last_article.blank?
        items.reverse.each do |i|
          begin 
          old_thing = Thing.find_by_link((i/"link").first.inner_html)
          if old_thing.blank?
            http2 = RubyTubesday.new
            story = Hpricot(http2.get((i/"link").first.inner_html))
            rawtext = (story/".story.last").first.inner_html        
            thing = Thing.create(
              :source => "wish",
              :title => (i/"title").first.inner_html,
              :body => (i/"description").first.to_plain_text.gsub(/<\/?[^>]*>/, ""),
              :link => (i/"link").first.inner_html,
              :created_at => Time.parse((i/"pubDate").first.inner_html),
              :extended_body => rawtext
            ) 
            term_extractor = Yahoo::TermExtractor.new(APP_ID) 
            thing.tag_with(term_extractor.extract_terms(rawtext))
            QuoteGenerator.quote_this(thing)
          end   
          rescue
            next
          end
        end
          rescue
            next
          end



      end


   end
       

  
  
end