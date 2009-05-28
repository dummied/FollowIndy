module TheFanFetch
  FEED_URL = "http://www.1070thefan.com/_Shared/Channels/Public/RSS/GetXMLDataForRSS.ashx?ChannelID=1042"
  
  def self.fetch
    last_article = Thing.find(:first, :conditions => "source = 'the_fan'", :order => "created_at DESC")
    http = RubyTubesday.new
    feed = Hpricot.XML(http.get(FEED_URL))
    items = (feed/"item")
    items = items.reject{|u| Time.parse((u/"pubDate").first.inner_html) < last_article.created_at} unless last_article.blank?
    items.reverse.each do |i|
      link = (i/"link").first.inner_html
      http2 = RubyTubesday.new
      story = Hpricot.XML(http2.get(link, :max_redirects => 10))
      rawtext = (story/".main_block").first.inner_html        
      thing = Thing.create_or_update_by(:link, {
        :source => "the_fan",
        :title => (i/"title").first.inner_html,
        :body => (i/"description").first.inner_html,
        :link => link,
        :created_at => Time.parse((i/"pubDate").first.inner_html),
        :extended_body => rawtext}
      ) 
      term_extractor = Yahoo::TermExtractor.new(APP_ID) 
      thing.tag_with(term_extractor.extract_terms(rawtext).collect{|t| t.to_s})  
      QuoteGenerator.quote_this(thing)

      
    end
    
    
    
  end
  
  
end