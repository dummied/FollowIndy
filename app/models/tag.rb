
# The Tag model. This model is automatically generated and added to your app if you run the tagging generator included with has_many_polymorphs.

class Tag < ActiveRecord::Base 
  
  has_slug :name 
  
  BAD_TAGS = ["ff", "rt", "blog", "ly", "live stream", "indianapolis star", "blip", "gd", "central indiana", "sports events", "breaking news", "news release", "nuvo", "eric berman", "6news", "wthr", "indystar", "tinyurl", "eyewitness news", "raquo", "latest local news", "indianapolis area", "admanager", "page nbsp", "type dom", "element", "ibsys", "hour news", "news 8", "indianapolis ap", "br", "amp", "lt", "4px", "indianapolis", "nbsp", "associated press", "quot"]

  DELIMITER = "," # Controls how to split and join tagnames from strings. You may need to change the <tt>validates_format_of parameters</tt> if you change this.

  # If database speed becomes an issue, you could remove these validations and rescue the ActiveRecord database constraint errors instead.
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  
  # Change this validation if you need more complex tag names.
  validates_format_of :name, :with => /^[a-zA-Z0-9\_\-\sé#]+$/, :message => "can not contain special characters"
  
  # Set up the polymorphic relationship.
  has_many_polymorphs :taggables, 
    :from => [:things], 
    :through => :taggings, 
    :dependent => :destroy,
    :skip_duplicates => false, 
    :parent_extend => proc {
      # Defined on the taggable models, not on Tag itself. Return the tagnames associated with this record as a string.
      def to_s
        self.map(&:name).sort.join(Tag::DELIMITER)
      end
    }         
    
  named_scope :cleaned, :conditions => ["tags.name not in (?)", BAD_TAGS]
  named_scope :by_date, lambda {|date| {:conditions => ["DATE(taggings.created_at) = ?", date]}}
  named_scope :rolling, :conditions => "taggings.created_at > '#{8.hours.ago.to_s(:db)}'"
    
  # Callback to strip extra spaces from the tagname before saving it. If you allow tags to be renamed later, you might want to use the <tt>before_save</tt> callback instead.
  def before_create 
    self.name = name.downcase.strip.squeeze(" ")
  end
  
  # Tag::Error class. Raised by ActiveRecord::Base::TaggingExtensions if something goes wrong.
  class Error < StandardError
  end      
  
  def self.find_popular(args = {}) 
     find(:all, :select => 'tags.*, count(*) as popularity', 
       :limit => args[:limit] || 10,
       :joins => "JOIN taggings ON taggings.tag_id = tags.id JOIN things on taggings.taggable_id = things.id",
       :conditions => args[:conditions],
       :group => "taggings.tag_id", 
       :order => "popularity DESC"  ) 
   end

    
end
