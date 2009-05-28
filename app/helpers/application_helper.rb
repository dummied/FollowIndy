module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end           
  
  def awesome_truncate(text, length = 30, truncate_string = " ...")
    return if text.nil?
    l = length - truncate_string.length
   text.length > l ? text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
  end  
  
  def make_title(content, params={})
     if content == "indystar"
       starter = "The Indianapolis Star"
     elsif content == "twitter"
       starter = "Twitter: Central Indiana"
     elsif content == "flickr"
       starter = "Flickr: Indianapolis"
     elsif content == "ibj"
       starter = "Indianapolis Business Journal"
     elsif content == "picky"
       starter = "PickyList.com"
     elsif content == "the_fan"
       starter = "1070 The Fan"
     elsif content == "pro"
       "Professional Journalists"
     elsif content == "public"
       "The Public at Large" 
     else
       starter = content.upcase
     end
     if params && params.has_key?(:date)
       starter + ": " + Time.parse(params[:date]).to_s
     end
     return starter    
  end
end
