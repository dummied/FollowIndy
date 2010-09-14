class SearchController < ApplicationController
  respond_to :html, :json, :atom
  
  def index
    if params[:_snowman]
      params.delete(:_snowman)
      redirect_to params
    else
      @by_date = Thing.search_by_days(params[:q])
      @things = Thing.search(
        params[:q], 
        :match_mode => :extended,
        :order => "created_at DESC", 
        :page => params[:page] || 1
      )
      @page_title = "Search for \"#{params[:q]}\""
      respond_to do |format|
        format.html {
          render :template => "things/index"
        }
        format.atom {
          render :template => "things/index"
        }
        format.json {
          render :json => @things.to_json
        }
      end
    end
  end
  
end