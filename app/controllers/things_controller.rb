class ThingsController < ApplicationController
  respond_to :html, :json, :atom
  
  protect_from_forgery :except => :create
  
  def create
    if params["secret"] && params["secret"] == "srgesthreth"
      link = params["thing"].delete("link")
      if (@thing = Thing.find_by_link(link.gsub(/&t=.+$/, ""))) && @thing != false
        if params["automated"] && params["automated"] == "true"
          render :nothing => true
        else
          redirect_to edit_thing_path(@thing)
        end
      else
        if params["automated"] && params["automated"] == "true"
          if params["delayed"] && params["delayed"] == "true"
            Thing.send_later(:delayed_save, params["thing"].merge("link" => link), params["feed"])
          else
            @thing = Thing.create!(params["thing"].merge("link" => link))
          end
          render :nothing => true
        else
          @thing = Thing.create!(params["thing"].merge("link" => link))
          redirect_to edit_thing_path(@thing)
        end
      end
    else
      render :nothing => true
    end
  end
  
  def edit
    @thing = Thing.find(params[:id])
    @source = @thing.origin
    render :layout => "minimal"
  end
  
  def update
    @thing = Thing.find(params[:id])
    @thing.update_attributes(params[:thing])
    redirect_to :layout => "minimal", :action => "thanks"
  end
  
  def show
    @thing = Thing.find(params[:id])
    respond_to do |format|
      format.html{ 
        @things = @thing.related
        @page_title = "Related to \"#{@thing.title}\""
        render :action => :index
      }
      format.json {
        render :json => @thing.to_json(:methods => :related)
      }
    end
  end
  
  def thanks
    render :layout => "minimal"
  end
  
  
  
  def index
    @things = Thing.order("created_at DESC").paginate(:page => params[:page] || 1)
    respond_with(@things)
  end
end
