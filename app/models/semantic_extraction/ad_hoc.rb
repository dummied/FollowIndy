require 'curl'
require 'nokogiri'

module SemanticExtraction
  module AdHoc
    include SemanticExtraction::UtilityMethods
    
    SemanticExtraction.valid_extractors << "ad_hoc"
    
    def self.extract_text(url)
      if is_url?(url)
        c = Curl::Easy.perform(url) do |curl|
          curl.follow_location = true
        end
        data = Nokogiri::HTML(c.body_str)
        # The Gannett Hack
        if (data/"#article")
          text = (data/"#article").inner_html
        else
          containers = (data/"div div")
          if containers.blank?
            return data.text
          else
            possibles = []
            containers.each_with_index do |c, index|
              possibles << {:index => index, :count => ((c/"p").length - (c/"div").sum{|u| (u/"p").length})}
            end
            text_index = possibles.max{|a,b| a[:count] <=> b[:count]}[:index]
            text = containers[text_index]
            text = text.inner
          end
        end
        if text.blank?
          text = SemanticExtraction.extract_text(url)
        end
        return text
      end
    end
      

  end
end