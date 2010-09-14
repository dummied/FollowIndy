class SourcesController < ApplicationController
  respond_to :html, :json, :atom
  
  def show
    @source = Source.where(:slug => params[:id]).first
    @things = @source.things.order("created_at DESC").paginate(:page => params[:page] || 1)
    @by_date = Thing.source_by_days(@source)
    @page_title = @source.name
    respond_to do |format|
      format.html {render :template => "things/index"}
      format.atom {render :layout => false, :template => "things/index"}
      format.json {render}
    end
  end
  
  # def update
  #   @source = Source.update_attributes(params[:source])
  #   redirect_to things_path
  # end
  
  def index
    @sources = Source.order("name").all.reject{|u| u.things.first.blank?}
  end
  
end
