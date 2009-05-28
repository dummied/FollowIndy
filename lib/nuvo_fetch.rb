module NuvoFetch
  FEEDS = [
    "http://nuvo.net/i/News/feed",
    "http://nuvo.net/i/Music/feed",
    "http://nuvo.net/i/Arts/feed",
    "http://nuvo.net/i/Entertainment/feed"
  ]
  
  def self.fetch
     last_article = Thing.find(:first, :conditions => "source = 'nuvo'", :order => "created_at DESC")
     FEEDS.each do |f| 
       http = RubyTubesday.new
       feed = Hpricot.XML(http.get(f))
       items = (feed/"item")
       items = items.reject{|u| Time.parse((u/"pubDate").first.inner_html) < last_article.created_at} unless last_article.blank?
       items.reverse.each do |i|  
         old_thing = Thing.find_by_link((i/"comments").first.inner_html.sub("#comments", ""))
         if old_thing.blank?
           http2 = RubyTubesday.new
           story = Hpricot(http2.get((i/"comments").first.inner_html.sub("#comments", "")))
           rawtext = (story/".node").first.inner_html        
           thing = Thing.create(
             :source => "nuvo",
             :title => (i/"title").first.inner_html,
             :body => (story/".node p").first.inner_html,
             :link => (i/"comments").first.inner_html.sub("#comments", ""),
             :created_at => Time.parse((i/"pubDate").first.inner_html),
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