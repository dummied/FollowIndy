module FlickrFetch
   KEY = "ba0bc05de10af7c670a388a3f2240982"
   SECRET = "aa02e97cf2938cf1"
   
   def self.fetch
     flickr = Flickr.new(:key => KEY, :secret => SECRET)
     last_photo = Thing.find(:first, :conditions => "source = 'flickr'", :order => "created_at DESC")
     min_date = (last_photo.blank? ? 1.days.ago : last_photo.created_at)
     photos = flickr.photos.search(:woe_id => "dO5.AiybBZ4_dE8m", :min_taken_date => min_date) 
     photos = photos.reject{|p| p.uploaded_at < last_photo.created_at} unless last_photo.blank?
     photos.reverse.each do |p|
       begin     
        
        thing = Thing.create(
          :source => "flickr",
          :title => p.title,
          :body => p.description,
          :link => p.photopage_url,
          :external_id => p.id,
          :external_data => {:square_thumb_url => p.image_url(:square), :user_name => p.owner_name}.to_yaml,
          :created_at => p.uploaded_at
        )
        
        if p.tags.blank?
          term_extractor = Yahoo::TermExtractor.new(APP_ID) 
          thing.tag_with(term_extractor.extract_terms(thing.title + " " + thing.body))
        else
          thing.tag_with(p.tags.split(" "))
        end  
      rescue
        next
      end
       
       
     end
     
   end
   
  
end