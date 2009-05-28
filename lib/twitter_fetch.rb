module TwitterFetch   
  def self.fetch
    rad = 25
    lat = 39.769063
    lng = -86.157961                
    last_tweet = Thing.find(:first, :conditions => "source = 'twitter'", :order => "created_at DESC")
    
    tweets = Twitter::Search.new().geocode(lat.to_f, lng.to_f, "#{rad}mi").since(last_tweet.external_id).per_page(100).fetch()["results"]
    tweets = tweets.reject{|u| Time.parse(u["created_at"]) < last_tweet.created_at} unless last_tweet.blank?
    tweets.reverse.each do |t|
      begin
      body = t["text"]
      unless body.first == "@"
       thing = Thing.create(
        :body => body,
        :external_id => t["id"],
        :link => "http://twitter.com/#{t["from_user"]}/statuses/#{t["id"]}",
        :created_at => Time.parse(t["created_at"]),
        :source => "twitter",
        :external_data => {:user_name => t["from_user"], :avatar_url => t["profile_image_url"]}
       )      
       if thing.body =~ /(#[\w|-]+)/
         matches = thing.body.scan(/(#[\w|-]+)/)
         matches = matches.collect{|u| u.first}
         thing.tag_with(matches, "hash")
       end
         
       term_extractor = Yahoo::TermExtractor.new(APP_ID) 
       thing.tag_with(term_extractor.extract_terms(thing.body)) 
     end
     rescue
       next
     end
    end 
  end   
  
end