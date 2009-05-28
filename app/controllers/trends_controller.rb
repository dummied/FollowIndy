class TrendsController < ApplicationController
  
  caches_action :index
   
  def index
    if context && (context != "pro") && (context != "public")
      conditions =  ["source = ?", context] 
      @page_title = "What #{make_title(context)} is talking about"
    elsif context && context == "pro"
      conditions = ["source in (?)", pro_sources]                    
      @page_title = "What Indy's professional journalists are talking about"
    elsif context && context == "public"
      conditions = ["source in (?)", public_sources] 
      @page_title = "What Indy's Twitter and Flickr users are talking about"
    else
      @page_title = "What Indy's talking about"
    end
    
    if params[:date] && valid_date(params[:date])
        @tags = Tag.cleaned.by_date(params[:date]).find_popular(:conditions => conditions) 
        @page_title = @page_title.sub(" are ", " were ").sub(" is ", " was ").sub(" about", "") + " #{time_ago_in_words(Time.parse(params[:date]))} ago"
    elsif params[:alltime] 
        @tags = Tag.cleaned.find_popular(:conditions => conditions, :limit => 20)
        @page_title = @page_title.sub(" is talking ", " typically talks ").sub(" are talking ", " typically talk ")   
    else                       
      @page_title = @page_title + " today"
      @tags = Tag.cleaned.rolling.find_popular(:conditions => conditions)
    end                                             
    
    @total = @tags.collect{|u| u.popularity.to_i}.sum
    
    respond_to do |format|
       format.html
       format.js { render :json => @tags.to_json }
       format.xml { render :xml => @tag.to_xml }
    end
      
    
    
    
  end
       
  
  private 
  
  def valid_date(string)
     begin
       Time.parse(string.gsub("-", "/"))  
       return true
     rescue
       return false 
     end
  end
  

  
  
  
  
  
end