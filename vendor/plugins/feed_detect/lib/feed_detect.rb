module FeedDetect 
  def self.included(base)
  base.class_eval do
    
    alias_method :original_custom, :custom
    
    def custom(mime_type, &block)  
      mime_type = mime_type.is_a?(Mime::Type) ? mime_type : Mime::Type.lookup(mime_type.to_s)

      if [:atom, :rss].include?(mime_type.to_sym)
        @controller.send(
          :instance_variable_set,
          "@feed_url".to_sym, 
          @controller.send(:url_for, :overwrite_params => {:format => mime_type.to_sym})
        ) 
      end

      original_custom(mime_type, &block)

    end 
    
  end
  end
end