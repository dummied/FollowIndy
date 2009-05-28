module ActionController
  module Caching
    module Actions
      class ActionCachePath  
        
        def initialize(controller, options = {}, infer_extension=true)
          if infer_extension and options.is_a? Hash
            request_extension = extract_extension(controller.request)
            options = options.reverse_merge(:format => request_extension)
          end
          path = controller.url_for(options).split('://').last 
          path = path.to_s + controller.request.query_string.to_s
          normalize!(path)
          if infer_extension
            @extension = request_extension
            add_extension!(path, @extension)
          end
          @path = URI.unescape(path)
        end
            
      end
    end
  end
end