module PickyFetch   
  FEED_URL = "http://pickylist.com/opensearch/atom/"
   
   
   def self.fetch
     last_article = Thing.find(:first, :conditions => "source = 'picky'", :order => "created_at DESC")
     http = RubyTubesday.new
     feed = Hpricot.XML(http.get(FEED_URL))
     items = (feed/"entry")
     items = items.reject{|u| Time.parse((u/"updated").first.inner_html) < last_article.created_at} unless last_article.blank?
     items.reverse.each do |i|  
       http2 = RubyTubesday.new  
       link = (i/"link").first["href"] 
       puts link
        story = Hpricot(open(link))
        rawtext = (story/"#PostDescription").first.inner_html
        thing = Thing.create_or_update_by(:link, {
          :source => "picky",
          :title => (i/"title").first.inner_html,
          :body => (i/"content").first.inner_html,
          :link => link,
          :created_at => Time.parse((i/"updated").first.inner_html),
          :extended_body => rawtext}
        )
        term_extractor = Yahoo::TermExtractor.new(APP_ID) 
        thing.tag_with(term_extractor.extract_terms(rawtext)) 
        QuoteGenerator.quote_this(thing)
       
     end
     
     
   end
  
end