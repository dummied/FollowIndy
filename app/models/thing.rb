class Thing < ActiveRecord::Base 
  class << ActiveRecord::Base
  def create_or_update(options = {})
    create_or_update_by(:id, options)
  end

  def create_or_update_by(field, options = {})
    find_value = options.delete(field)
    record = find(:first, :conditions => {field => find_value}) || self.new
    record.send field.to_s + "=", find_value
    record.attributes = options
    record.save!
    record
  end

  def method_missing_with_create_or_update(method_name, *args)
    if match = method_name.to_s.match(/create_or_update_by_([a-z0-9_]+)/)
      field = match[1].to_sym
      create_or_update_by(field,*args)
    else
      method_missing_without_create_or_update(method_name, *args)
    end
  end

  alias_method_chain :method_missing, :create_or_update
  end   
  
  
  define_index do
     indexes :title
     indexes tags.name, :as => :tag_names
     indexes :body
     indexes :extended_body
     
     has :source, :type => :string
     has :created_at, :as => :date, :sortable => true
     
     set_property :delta => true
  end  
  
  def partial
     if source == "twitter"
       partial = "tweet"
     elsif source == "flickr"
       partial = "flickr"
     else
       partial = "thing"
     end
  end   
  
  def summary
    if body.blank?
      "No summary available"
    else
      body
    end
  end  
  
  def data
    YAML::load(external_data)
  end
  
  def hed
    title || "No title"
  end
end 