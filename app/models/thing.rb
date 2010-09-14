class Thing < ActiveRecord::Base
  
  # belongs_to :source
  belongs_to :feed
  has_one :origin, :class_name => "Source", :primary_key => "source_id", :foreign_key => "id"
  
  accepts_nested_attributes_for :origin
  
  before_validation :extract, :sourcify, :tag_this, :dupe_check, :on => :create
  
  before_save :clean
  
  define_index do
     indexes :title
     indexes :summary
     indexes :extended_body
     indexes :tag_list 
     indexes origin.slug, :as => :source_slug
    
     has :id
     has "CAST(DATE(things.created_at) as datetime)", :as => :date, :sortable => true, :facet => true, :type => :datetime
     has :created_at, :sortable => true
     
  end 
  
  
  def source
    origin.blank? ? feed.source : origin
  end
    
  def self.delayed_save(options={}, feed=nil)
    self.create(options)
    # if feed
    #   self.feed = Feed.find_by_url(feed)
    #   self.save!
    # end
  end
  
  def tags
    tag_list.split(", ")
  end
  
  def tag_this
    self.tag_list = SemanticExtraction.find_keywords(extended_body).collect{|t| t.parameterize.gsub("-", " ")}.join(", ")    
  end
  
  def categories
    feed.blank? ? [] : feed.categories.split(",")
  end
      
  
  def self.hijack_update(link, attributes)
    attributes[:source_id] = Source.where(:slug => link.match(/\w{3,5}:\/\/(\w*\.|)(.+)\.\w{1,3}\/.*/)[2].gsub(".", "_")).first.id if attributes[:source_id].blank?
    attributes[:title] = self.fetch_title(link) if attributes[:title].blank?
    if thing = Thing.where(["(link = ? or title = ?) and source_id = ?", link.gsub(/&t=.+$/, ""), attributes[:title], attributes[:source_id]]).first
      thing.update_attributes(attributes)
      # thing.tag_this
      thing.save!
      return thing
    else
      return false
    end
  end
  
  def sourcify
    if origin.blank?
      matches = link.match(/\w{3,5}:\/\/(\w*\.|)(.+)\.\w{1,3}\/.*/)
      if matches[1].blank? || matches[1] == "www."
        root = matches[2].gsub(".", "_")
      else
        root = (matches[1] + matches[2]).gsub(".", "_")
      end
      unless source = Source.where(:slug => root).first
        source = Source.create(:slug => root, :name => root.capitalize, :home_url => link.match(/(\w{3,5}:\/\/.+\.\w{2,4}\/).*/)[1])
      end
      self.source_id = source.id
    end
  end
  
  # Attempts to extract the extended_body, body and title from an arbitrary URL. By necessity, extended_body is very rough right now.
  # However, in limited testing, so far it is nailing the primary content div.
  def extract
    if summary.blank? || title.blank?
      # http = RubyTubesday.new
      # raw = http.get(link)
      c = Curl::Easy.perform(self.link) do |curl|
        curl.follow_location = true
      end
      data = Nokogiri::HTML(c.body_str)
      no_body = false
    end
    if extended_body.blank?
      self.extended_body = Sanitize.clean(SemanticExtraction::AdHoc.extract_text(link))
    end
    if summary.blank?
      if meta_desc = data.css("meta[name='description']").first 
        content = meta_desc['content']
      elsif no_body
        content = "No summary available"
      else
        content = Nokogiri::HTML(extended_body)
        content = content.css("p").first.text
      end
      self.summary = content
    end
    if title.blank?
      self.title = data.css("title").first.children.first.to_s
    end
  end
  
  def self.fetch_title(link)
    c = Curl::Easy.perform(link) do |curl|
      curl.follow_location = true
    end
    data = Nokogiri::HTML(c.body_str)
    data.css("title").first.children.first.to_s
  end
  
  def clean
    self.link = link.gsub(/&t=.+$/, "")
    self.title = Sanitize.clean(self.title)
    self.summary = Sanitize.clean(self.summary)
  end
  
  def related(limit=100)
    query = "(" + tags.collect{|u| '"' + u + '"'}.join(" & ") + ")"
    query << " | "
    query << "(" + tags.collect{|u| '"' + u + '"'}.join(" | ") + ")"
    date1 = (created_at - 2.weeks)
    date2 = (created_at + 2.weeks)
    search = Thing.search(
     query,
     :without => {:id => self.id},
     :with => {:created_at => date1..date2},
     :match_mode => :extended, 
     :sort_mode => :extended,
     :limit => limit,
     :order => "@weight DESC"
    )
    @search = []
    unless search.blank?
      search.each_with_weighting do |p, weight|
        if weight >= 9514
          @search << p
        end
      end
    end
      
       # tags_to_find = tags.collect { |t| t.name }
       # 
       #       exclude_self = "things.id != #{self.id} AND"
       #       @search = Thing.paginate(
       #         :select     => "things.*, COUNT(tags.id) AS count", 
       #         :from       => "things, tags, taggings",
       #         :conditions => ["#{exclude_self} things.id = taggings.taggable_id AND taggings.taggable_type = 'Thing' AND taggings.tag_id = tags.id AND tags.name IN (?) and COUNT(tags.id) > 0", tags_to_find],
       #         :group      => "things.id",
       #         :order      => "count DESC",
       #         :per_page   => per_page,
       #         :page       => page
       #         ) 
       # @search = WillPaginate::Collection.create(page, per_page, search.total_entries) do |pager|
       #   pager.replace(@search)
       # end
       return @search
 
  end
  
  def related_count(uncached=false)
    if uncached || cached_related_count.blank?
      self.cached_related_count = related.length
      self.save!
      return cached_related_count
    else
      return cached_related_count
    end
  end
  
  def self.refresh_related_counts
    Thing.where("created_at > #{2.weeks.ago}").find_each do |thing|
      thing.cached_related_count = related.count
      thing.save!
    end
  end
  
  def self.find_tagged_with(tag, this_page=1)
    @things = Thing.search(
      "@tag_list '#{tag}'",
      :match_mode => :extended,
      :page => this_page,
      :order => :created_at,
      :sort_mode => :desc
    )
  end
  
  def self.tag_by_days(tag)
    @dates = Thing.facets(
      "@tag_list '#{tag}'",
      :match_mode => :extended
    )
    return fill_days(@dates[:date].inject({}){|memo,(k,v)| memo[k.to_date] = v; memo})
  end
  
  def self.source_by_days(source)
    @dates = Thing.facets(
      "@source_slug #{source.slug}",
      :match_mode => :extended
    )
    return fill_days(@dates[:date].inject({}){|memo,(k,v)| memo[k.to_date] = v; memo})
  end
  
  def self.search_by_days(query)
    @dates = Thing.facets(
      query,
      :match_mode => :extended
    )
    return fill_days(@dates[:date].inject({}){|memo,(k,v)| memo[k.to_date] = v; memo})
  end
  
  def to_json(options={})
    options = options.merge(:except => :extended_body)
    super(options)
  end
  
  private
  
  def self.fill_days(dates)
    source = Source.find_by_slug("wthr")
    range = Thing.order("created_at ASC").where("source_id != #{source.id} and created_at is not null").first.created_at.to_date..Thing.order("created_at DESC").first.created_at.to_date
    range.each do |day|
      dates[day] = 0 unless dates[day]
    end
    return dates.collect{|key, value| OpenStruct.new(:date => key, :value => value)}.sort_by{|u| u.date}
  end
  
  def dupe_check
    if thing = Thing.where(["(link = ? or title = ?) and source_id = ?", link.gsub(/&t=.+$/, ""), title, source_id]).first
      return false
    end
  end
  
end
