module Indystar
  def self.fetch(url=nil, summary=nil, time=nil)
     if url.blank?
       last_article = Thing.find(:first, :order => "updated_at DESC", :conditions => "source = 'indystar'") 
       http = RubyTubesday.new
       feed = Hpricot(http.get("http://www.indystar.com/apps/pbcs.dll/section?Category=XMLFEED&template=rss&mime=XML"))
       to_be_fetched = []
       (feed/"item").each do |i| 
         if last_article.blank?
           to_be_fetched << [(i/"guid").inner_html.gsub("&amp;", "&"), (i/"description").inner_html, Time.parse((i/"pubdate").inner_html)]
         else
           to_be_fetched << [(i/"guid").inner_html.gsub("&amp;", "&"), (i/"description").inner_html, Time.parse((i/"pubdate").inner_html)] unless Time.parse((i/"pubdate").inner_html) < last_article.updated_at
         end
       end
       to_be_fetched.reverse.each do |f|
         begin
         self.fetch(f[0] + "&mime=XML", f[1])
       rescue
         next
       end
       end
     else 
       http = RubyTubesday.new
       story = Hpricot(http.get(url))  
       old_thing = Thing.find_by_link(url.sub("&template=xml&mime=XML", ""))
       if (old_thing.blank? && time.blank?) || old_thing.created_at.blank?
         time = Time.now
       elsif !old_thing.blank?
         time = old_thing.created_at
       end
       article = Thing.create_or_update_by(:link, {:title => (story/"title").first.inner_html,
                        :link => url.sub("&template=xml&mime=XML", ""),
                        :source => "indystar",
                        :body => summary.windows1252_to_utf8,
                        :created_at => time,
                        :extended_body => (story/"body").first.inner_html})
       term_extractor = Yahoo::TermExtractor.new(APP_ID) 
       article.tag_with(term_extractor.extract_terms((story/"body").first.inner_html)) 
       QuoteGenerator.quote_this(article)
       return article
     end
     
  end 
  
end
