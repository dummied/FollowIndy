# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

source = Source.create(:slug => "indystar", :name => "The Indianapolis Star", :home_url => "http://www.indystar.com")
indystar_things = Thing.find_all_by_old_source("indystar").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "ibj", :name => "Indiana Business Journal", :home_url => "http://www.ibj.com")
ibj_things = Thing.find_all_by_old_source("ibj").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "nuvo", :name => "Nuvo", :home_url => "http://www.nuvo.net")
nuvo_things = Thing.find_all_by_old_source("nuvo").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "theindychannel", :name => "WRTV", :home_url => "http://www.theindychannel.com")
rtv_things = Thing.find_all_by_old_source("rtv").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "wibc", :name => "WIBC", :home_url => "http://www.wibc.com")
wibc_things = Thing.find_all_by_old_source("wibc").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "wishtv", :name => "WISH", :home_url => "http://www.wishtv.com")
wish_things = Thing.find_all_by_old_source("wish").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "wthr", :name => "WTHR", :home_url => "http://www.wthr.com")
wthr_things = Thing.find_all_by_old_source("wthr").each do |p|
  p.source_id = source.id
  p.save!
end

source = Source.create(:slug => "1070thefan", :name => "1070 The Fan", :home_url => "http://www.1070thefan.com")
thefan_things = Thing.find_all_by_old_source("the_fan").each do |p|
  p.source_id = source.id
  p.save!
end

# Remove sources we're not going to be using anymore (at least in their present form)

things = Thing.all(:conditions => ["old_source in (?)", ["picky", "flickr"]])

things.each do |t|
  t.destroy
end

# Clean up tag_list

Thing.find_each do |thing|
  unless thing.tag_list.blank?
    thing.tag_list = thing.tag_list.split(",").join(", ")
    thing.save!
  end
end

# Let's make some feeds.

source = Source.find_by_slug("indystar")

Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=TOPSTORIES&amp;template=rss&amp;mime=XML", :name => "IndyStar: Today's top stories", :source_id => source.id, :categories => "pro, print, news")
Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=LOCAL&amp;template=rss&amp;mime=XML", :name => "IndyStar: All Communities", :source_id => source.id, :categories => "pro, print, communities, news")
Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=NEWS&amp;template=rss&amp;mime=XML", :name => "IndyStar: All News", :source_id => source.id, :categories => "pro, print, news")
Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=SPORTS&amp;template=rss&amp;mime=XML", :name => "IndyStar: All Sports", :source_id => source.id, :categories => "pro, print, sports")
Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=BUSINESS&amp;template=rss&amp;mime=XML", :name => "IndyStar: All Business", :source_id => source.id, :categories => "pro, print, business")
Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=LIVING&amp;template=rss&amp;mime=XML", :name => "IndyStar: All Living", :source_id => source.id, :categories => "pro, print, lifestyle")
Feed.create(:url => "http://www.indystar.com/apps/pbcs.dll/section?Category=OPINION&amp;template=rss&amp;mime=XML", :name => "IndyStar: All Opinion", :source_id => source.id, :categories => "pro, print, opinion")
Feed.create(:url => "http://blogs.indystar.com/coltsinsider/index.xml", :name => "Ask the Expert: Colts", :source_id => source.id, :categories => "pro, blog, print, colts, sports")
Feed.create(:url => "http://blogs.indystar.com/philb/index.xml", :name => "Phil B.", :source_id => source.id, :categories => "pro, blog, print, sports")
Feed.create(:url => "http://blogs.indystar.com/pacersinsider/index.xml", :name => "Pacers Insider", :source_id => source.id, :categories => "pro, blog, print, pacers, sports")
Feed.create(:url => "http://blogs.indystar.com/hoosiersinsider/index.xml", :name => "Hoosiers Insider", :source_id => source.id, :categories => "pro, blog, print, hoosiers, sports")
Feed.create(:url => "http://blogs.indystar.com/purdue/index.xml", :name => "Boilers Insider", :source_id => source.id, :categories => "pro, blog, print, purdue, sports")
Feed.create(:url => "http://blogs.indystar.com/butler/index.xml", :name => "Butler Insider", :source_id => source.id, :categories => "pro, blog, print, bulter, sports")
Feed.create(:url => "http://blogs.indystar.com/racingexpert/index.xml", :name => "Ask the Expert: IRL", :source_id => source.id, :categories => "pro, blog, print, racing, sports")
Feed.create(:url => "http://blogs.indystar.com/recruitingcentral/index.xml", :name => "Recruiting Central", :source_id => source.id, :categories => "pro, blog, print, preps, recruiting, sports")
Feed.create(:url => "http://blogs.indystar.com/preps/index.xml", :name => "Preps Insider", :source_id => source.id, :categories => "pro, blog, print, preps, sports")
Feed.create(:url => "http://blogs.indystar.com/westsports/index.xml", :name => "Preps Out West", :source_id => source.id, :categories => "pro, blog, print, preps, sports")
Feed.create(:url => "http://blogs.indystar.com/crime/index.xml", :name => "Justice Watch", :source_id => source.id, :categories => "pro, blog, print, crime")
Feed.create(:url => "http://blogs.indystar.com/pharma/index.xml", :name => "Take After Meals", :source_id => source.id, :categories => "pro, blog, print, health_care")
Feed.create(:url => "http://blogs.indystar.com/starwatch/index.xml", :name => "Starwatch", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/starneighbors/index.xml", :name => "Star Neighbors", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/transit/index.xml", :name => "Travels with Erika", :source_id => source.id, :categories => "pro, blog, print, transportation")
Feed.create(:url => "http://blogs.indystar.com/ourschools/index.xml", :name => "Our Schools", :source_id => source.id, :categories => "pro, blog, print, education")
Feed.create(:url => "http://blogs.indystar.com/board/index.xml", :name => "The Board", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/bottomline/index.xml", :name => "The Bottom Line", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/firstthoughts/index.xml", :name => "First Thoughts", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/freshthoughts/index.xml", :name => "Fresh Thoughts", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/intouch/index.xml", :name => "In Touch", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/fitforlife/index.xml", :name => "Fit for Life", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/indykitchen/index.xml", :name => "Indy Kitchen", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/upstage/index.xml", :name => "Upstage", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/style/index.xml", :name => "Style", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/home/index.xml", :name => "By Design", :source_id => source.id, :categories => "pro, blog, print")
Feed.create(:url => "http://blogs.indystar.com/geek/index.xml", :name => "Geeking Out", :source_id => source.id, :categories => "pro, blog, print")

source = Source.find_by_slug("ibj")

Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=4", :name => "Property Lines", :source_id => source.id, :categories => "pro, business, print, real_estate")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=5", :name => "Lou Harry's A&amp;E", :source_id => source.id, :categories => "pro, business, print, entertainment")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=6", :name => "NewsTalk", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=7", :name => "The Score", :source_id => source.id, :categories => "pro, business, print, sports")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=9", :name => "Latest News", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=15", :name => "Dining Reviews", :source_id => source.id, :categories => "pro, business, print, dining")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=16", :name => "Real Estate &amp; Retail", :source_id => source.id, :categories => "pro, business, print, real_estate")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=17", :name => "Health Care &amp; Life Sciences", :source_id => source.id, :categories => "pro, business, print, health_care")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=18", :name => "Sports Business", :source_id => source.id, :categories => "pro, business, print, sports")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=19", :name => "A&amp;E ETC.", :source_id => source.id, :categories => "pro, business, print, entertainment")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=39", :name => "Education &amp; Workforce", :source_id => source.id, :categories => "pro, business, print, education")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=21", :name => "Health Care &amp; Insurance", :source_id => source.id, :categories => "pro, business, print, health_care")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=22", :name => "Small Business", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=23", :name => "Banking &amp; Finance", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=24", :name => "Communications", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=25", :name => "Energy &amp; Environment", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=42", :name => "Workplace Issues", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=27", :name => "Law", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=28", :name => "Manufacturing &amp; Technology", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=29", :name => "Philanthropy", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=31", :name => "Regional News", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=34", :name => "Auto Industry", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=35", :name => "News &amp; Analysis", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=36", :name => "Behind the News", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=40", :name => "Government &amp; Economic Development", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=41", :name => "Transportation, Distribution &amp; Logistics", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=43", :name => "Lou's Views", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=44", :name => "Inside Dish", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=45", :name => "Leading Questions", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=46", :name => "Opinion: Editorial", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=47", :name => "Opinion: Eye on the Pie", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=48", :name => "Opinion: Viewpoint", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=49", :name => "Opinion: Letters to the Editor", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=50", :name => "Opinion: Commentary", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=51", :name => "Opinion: Surf This", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=53", :name => "Opinion: Notions", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=54", :name => "Opinion: Benner on Sports", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=55", :name => "Opinion: Economic Analysis", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=56", :name => "Opinion: Investing", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=57", :name => "Opinion: Return on Technology", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=58", :name => "Mickey Maurer", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=59", :name => "Eli Lilly &amp; Co.", :source_id => source.id, :categories => "pro, business, print, health_care")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=60", :name => "Simon Property", :source_id => source.id, :categories => "pro, business, print")
Feed.create(:url => "http://www.ibj.com/rss/feed?rssId=61", :name => "WellPoint Inc.", :source_id => source.id, :categories => "pro, business, print, health_care")

source = Source.find_by_slug("nuvo")

Feed.create(:url => "http://www.nuvo.net/indianapolis/Rss.xml", :name => "Nuvo.net full feed", :source_id => source.id, :categories => "pro, print, alternative")

source = Source.find_by_slug("rtv")

Feed.create(:url => "http://www.theindychannel.com/news/topstory.rss", :name => "WRTV news", :source_id => source.id, :categories => "pro, television")

source = Source.find_by_slug("wish")

Feed.create(:url => "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=10001", :name => "WISH news feed", :source_id => source.id, :categories => "pro, television")
Feed.create(:url => "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=10002", :name => "WISH weather feed", :source_id => source.id, :categories => "pro, teleivision, weather")
Feed.create(:url => "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=10004", :name => "WISH sports feed", :source_id => source.id, :categories => "pro, television, sports")
Feed.create(:url => "http://www.wishtv.com/feeds/rssFeed?siteId=20000&obfType=RSS_FEED&categoryId=10022", :name => "WISH Indy Style", :source_id => source.id, :categories => "pro, television")

source = Source.find_by_slug("wthr")

Feed.create(:url => "http://www.wthr.com/global/category.asp?c=23903&clienttype=rss", :source_id => source.id, :name => "WTHR", :categories => "pro, television")
Feed.create(:url => "http://www.wthr.com/global/category.asp?c=144594&clienttype=rss", :source_id => source.id, :name => "WTHR", :categories => "pro, television")
Feed.create(:url => "http://www.wthr.com/global/category.asp?c=79076&clienttype=rss", :source_id => source.id, :name => "WTHR", :categories => "pro, television")
Feed.create(:url => "http://www.wthr.com/global/category.asp?c=79206&clienttype=rss", :source_id => source.id, :name => "WTHR", :categories => "pro, television")

source = Source.find_by_slug("wibc")

Feed.create(:url => "http://www.wibc.com/_Shared/Channels/Public/RSS/GetXMLDataForRSS.ashx?ChannelID=1", :source_id => source.id, :name => "WIBC news", :categories => "pro, radio")

source = Source.find_by_slug("1070thefan")

Feed.create(:url => "http://www.1070thefan.com/_Shared/Channels/Public/RSS/GetXMLDataForRSS.ashx?ChannelID=1042", :source_id => source.id, :name => "1070 The Fan feed", :categories => "pro, radio, sports")

source = Source.create(:slug => "blueindiana", :name => "BlueIndiana", :home_url => "http://www.blueindiana.net")
Feed.create(:source_id => source.id, :url => "http://feeds.feedburner.com/BlueIndiana", :categories => "blog, politics, democrats", :name => "BlueIndiana main feed")

source = Source.create(:slug => "advanceindiana_blogspot", :name => "Advance Indiana", :home_url => "http://www.advanceindiana.blogspot.com/")
Feed.create(:source_id => source.id, :url => "http://advanceindiana.blogspot.com/feeds/posts/default", :categories => "politics, blog", :name => "Advance Indiana")

source = Source.create(:slug => "eyeonindianapolis_blogspot", :name => "Eye on Indianapolis", :home_url => "http://eyeonindianapolis.blogspot.com/")
Feed.create(:source_id => source.id, :url => "http://eyeonindianapolis.blogspot.com/feeds/posts/default", :categories => "blog, politics", :name => "Eye on Indianapolis feed")

source = Source.create(:slug => "indianapolistimesblog_blogspot", :name => "Indianapolis Times Blog", :home_url => "http://www.indianapolistimesblog.blogspot.com/")
Feed.create(:source_id => source.id, :url => "http://indianapolistimesblog.blogspot.com/feeds/posts/default", :categories => "blog, news", :name => "Indianapolis Times Blog")

source = Source.create(:slug => "aloyalopposition", :name => "A Loyal Opposition", :home_url => "http://aloyalopposition.in/")
Feed.create(:source_id => source.id, :url => "http://aloyalopposition.in/feed/", :categories => "blog, politics", :name => "A Loyal Opposition feed")

source = Source.create(:slug => "hadenoughindy_blogspot", :name => "Had enough, Indy?", :home_url => "http://hadenoughindy.blogspot.com/")
Feed.create(:source_id => source.id, :url => "http://hadenoughindy.blogspot.com/feeds/posts/default", :categories => "blog, politics, taxes", :name => "Had enough, Indy? feed")

source = Source.create(:slug => "indianalawblog", :name => "Indiana Law Blog", :home_url => "http://www.indianalawblog.com/")
Feed.create(:source_id => source.id, :url => "http://www.indianalawblog.com/atom.xml", :categories => "law, blog", :name => "Indiana Law Blog feed")