class TagsController < ApplicationController
   
  def show
    check_slug!(@tag = Tag.find(params[:id]))
    if context && (context != "pro") && (context != "public")
      conditions =  ["source = ?", context]
    elsif context && context == "pro"
      conditions = ["source in (?)", pro_sources]
    elsif context && context == "public"
      conditions = ["source in (?)", public_sources]
    end
     @things = @tag.things.paginate(
      :conditions => conditions,
      :order => "created_at DESC",
      :page => page,
      :per_page => 20
     ) 
    @page_title = "Tag: #{@tag.name}"
    respond_to do |format|
       format.html { render :template => "shared/list"}
       format.js {render :json => @things.to_json(:except => :extended_body)}
       format.xml{render :xml => @things.to_xml(:except => :extended_body)}
       format.atom { render :template => "shared/list" }
    end
    
  end
  
  
  
  
  
end