class TagsController < ApplicationController
  respond_to :html, :json, :atom
  
  
  def show
    @things = Thing.find_tagged_with(params[:id], params[:page] || 1)
    respond_to do |format|
      format.html {
        @page_title = "Tagged with \"#{params[:id]}\""
        @by_date = Thing.tag_by_days(params[:id])
        render :template => "things/index"
      }
      format.json {
        render :json => @things.to_json
      }
      format.atom {
        render :template => "things/index"
      }
    end
    
  end
  
  
  
end