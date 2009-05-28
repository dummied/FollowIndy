require 'calais'

module QuoteGenerator 
  
  CALAIS_KEY = "YOUR_CALAIS_KEY_HERE"
   
  def self.quote_this(thing)
    if thing.extended_body and !thing.extended_body.blank?
      begin  
      resp = Calais.process_document(:content => thing.extended_body, :content_type => :html, :license_id => "g8kd3wt5nghbsg84fbhxppkp")
      quotes = resp.relations.select{|u| u.type == "Quotation"}
      quotes.each do |q| 
        unless Quote.find_by_body(q.attributes["quote"])
         quote = Quote.new(
          :body => q.attributes["quote"],
          :thing_id => thing.id
         ) 
         person = resp.entities.select{|u| u.hash.value == q.attributes['person'].value}.first.attributes["name"]
         quote.quoted = person
         quote.save 
       end
      end   
      
      if thing.tags.blank?
        thing.tag_with(resp.entities.collect{|p| p.attributes["name"]}) 
      end
    rescue 
      end
      
    end                                   
             
  end
  
  
  
  
  
  
  
end
