class SearchesController < ApplicationController
   
  def index
    if params[:topic] && params[:topic] == 'traffic'
	    query = "(465 | 65 | 69 | 70) & (crash | wreck | traffic | accident -sentence -bill -air)"
	    query_name = "Traffic reports"  
    elsif params[:topic] && params[:topic] == 'crime'
      query = "(police & (shooting | robbery | arrest)) | (court & judge & (murder | robbery | crime))"
      query_name = "Crime reports" 
    else
	    query = params[:query]
	    query_name = params[:query]
    end		
       @things = Thing.search(
                   query, 
                   :page => page, 
                   :per_page => 20,
                   :order => "date DESC",
		   :match_mode => :boolean
              )     
     @page_title = "Search for \"#{query_name}\""
     
     respond_to do |format|
        format.html {render :template => "shared/list"}
        format.js {render :json => @things.to_json(:except => :extended_body)}
        format.xml{render :xml => @things.to_xml(:except => :extended_body)}
        format.atom { render :template => "shared/list" }
     end
    
    
  end
  
  
  
  
end
