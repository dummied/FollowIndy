xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   (@page_title ? @page_title : "FollowIndy")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :format => :html)
  xml.id      url_for(:only_path => false, :format => :html)
  xml.updated @things.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @things.any?
  xml.author  { xml.name "FollowIndy" }

  @things.each do |post|
    xml.entry do
      xml.title   post.title
      xml.link    "rel" => "alternate", "href" => post.link
      xml.id      post.link
      xml.updated post.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name post.source.name }
      xml.summary post.summary
      xml.content "type" => "html" do
        xml.text! post.summary
      end
    end
  end

end