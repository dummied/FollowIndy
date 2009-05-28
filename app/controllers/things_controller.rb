class ThingsController < ApplicationController
    
  def index 
    if context && (context != "pro") && (context != "public")
      conditions =  ["source = ?", context]
    elsif context && context == "pro"
      conditions = ["source in (?)", pro_sources]
    elsif context && context == "public"
      conditions = ["source in (?)", public_sources]
    end  
     @things = Thing.paginate( 
      :conditions => conditions,
      :order => "created_at DESC",
      :page => page,
      :include => [:tags],
      :per_page => 20
     )   
     
     unless params[:no_title]
       @page_title = make_title(context) 
     end
     
    respond_to do |format|
       format.html {render :template => "shared/list"}
       format.js {render :json => @things.to_json(:except => :extended_body)}
       format.xml{render :xml => @things.to_xml(:except => :extended_body)}
       format.atom { render :template => "shared/list" }
    end
  end   
  
end     
