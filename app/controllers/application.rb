class ApplicationController < ActionController::Base

  helper :all     
  
  include ActionView::Helpers::DateHelper

  protect_from_forgery

  include HoptoadNotifier::Catcher
  
  def page
    params[:page] || 1
  end
  
  def context
    if !request.subdomains.blank? && (request.subdomains.first != 'www')
      @context = request.subdomains.first
    elsif params[:context]
      @context = params[:context]
    else
      @context = nil
    end 
    return @context
  end  
  
  private
  def make_title(content)
     if content == "indystar"
       "The Indianapolis Star"
     elsif content == "twitter"
       "Twitter: Central Indiana"
     elsif content == "flickr"
       "Flickr: Indianapolis"
     elsif content == "ibj"
       "Indianapolis Business Journal"
     elsif content == "picky"
       "PickyList.com"
     elsif content == "the_fan"
       "1070 The Fan" 
     elsif content == "pro"
       "Professional Journalists"
     elsif content == "public"
       "The Public at Large"
     elsif content.blank?
       ""
     else
       content.upcase
     end    
  end  
  
  def pro_sources
     ["wibc", "indystar", "nuvo", "wthr", "wish", "rtv", "ibj", "the_fan"]
  end 
  
  def public_sources
    ["twitter", "flickr", "picky"]
  end

end
