module WthrFetch
  FEEDS = [
     "http://www.wthr.com/global/category.asp?c=23903&clienttype=rss",
     "http://www.wthr.com/global/category.asp?c=144594&clienttype=rss",
     "http://www.wthr.com/global/category.asp?c=79076&clienttype=rss",
     "http://www.wthr.com/global/category.asp?c=79206&clienttype=rss"
   ]

   def self.fetch
      last_article = Thing.find(:first, :conditions => "source = 'wthr'", :order => "created_at DESC")
      FEEDS.each do |f| 
        http = RubyTubesday.new
        feed = Hpricot.XML(http.get(f))
        items = (feed/"item")
        to_be_processed = []
        items.each do |i|
          time_start = (i/"guid").first.inner_html
          start = time_start.length - 19
          time = time_start[start..-1]
          if !last_article.blank? && (Time.parse(time) > last_article.created_at)
            to_be_processed << [i, time]
          elsif last_article.blank?
            to_be_processed << [i, time]
          end
        end
          

        to_be_processed.reverse.each do |i, time|
          old_thing = Thing.find_by_link((i/"link").first.inner_html)
          if old_thing.blank?
            http2 = RubyTubesday.new
            story = Hpricot.XML(http2.get((i/"link").first.inner_html))
            rawtext = (story/"#storyBody").first.inner_html        
            thing = Thing.create(
              :source => "wthr",
              :title => (i/"title").first.inner_html.sub("<![CDATA[", "").sub("]]>", ""),
              :body => (i/"description").first.inner_html.sub("<![CDATA[", "").sub("]]>", ""),
              :link => (i/"link").first.inner_html,
              :created_at => Time.parse(time) + 3.hours,
              :extended_body => rawtext
            ) 
            term_extractor = Yahoo::TermExtractor.new(APP_ID) 
            thing.tag_with(term_extractor.extract_terms(rawtext)) 
            QuoteGenerator.quote_this(thing)
          end   

        end

        end



   end
  
  
end