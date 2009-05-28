module IbjFetch
   FEED_URL = "http://cms.ibj.com/ASPXPages/5CMSRSSFeeds/RSSChannel.aspx?ID=1"
   STARTER = "http://www.ibj.com/html/detail_page_Full.asp?content="
   
   def self.fetch
      last_article = Thing.find(:first, :conditions => "source = 'ibj'", :order => "created_at DESC")
      http = RubyTubesday.new
      feed = Hpricot.XML(http.get(FEED_URL))
      items = (feed/"item")
      items = items.reject{|u| Time.parse((u/"pubDate").first.inner_html) < last_article.created_at} unless last_article.blank?
      items.reverse.each do |i|  
        begin
        content_id = (i/"guid").first.inner_html.sub("http://www.ibj.com/html/detail_page.asp?content=FrontEndArticlesDetailPage.aspxQuestionMarkArticleIdEqual", "").sub("AmpersandRSSEqual1", "")
        link = STARTER + content_id
        http2 = RubyTubesday.new
        story = Hpricot(http2.get(link))
        spans = (story/"span") 
        spans = spans.reject{|u| !u.to_s.include? "font-family:arial; font-size:9pt; color:black;"}
        rawtext = spans.first.inner_html        
        thing = Thing.create_or_update_by(:link, {
          :source => "ibj",
          :title => (i/"title").first.inner_html,
          :body => (i/"description").first.inner_html,
          :link => link,
          :external_id => content_id,
          :created_at => Time.parse((i/"pubDate").first.inner_html),
          :extended_body => rawtext}
        ) 
        term_extractor = Yahoo::TermExtractor.new(APP_ID) 
        thing.tag_with(term_extractor.extract_terms(rawtext)) 
        QuoteGenerator.quote_this(thing)
        
      rescue
        next
      end
        
      end
     
     
   end  
   

  
  
  
end      


