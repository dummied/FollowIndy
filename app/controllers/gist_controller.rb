class GistController < ApplicationController  
  
  def index
     @quotes = Quote.paginate(
      :order => "created_at DESC",
      :page => page,
      :per_page => 20
     )
     
     respond_to do |format|
       format.html
       format.js { render :json => @quotes.to_json}
       format.xml { render :xml => @quotes.to_xml }
     end
    
  end   
  
  def show
     @quote = Quote.find params[:id]
     respond_to do |format|
        format.html
        format.js { render :json => @auote.to_json(:include => :thing)}
        format.xml { render :xml => @auote.to_xml(:include => :thing)}
     end
    
  end
  
  
  
  
  
  
  
  
end