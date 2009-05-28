# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever   

set :cron_log, "#{RAILS_ROOT}/log/cron_log.log"

every 3.minutes do
  runner "TwitterFetch.fetch"
end

every 15.minutes do
  runner "NuvoFetch.fetch"
  runner "RtvFetch.fetch"
end                      

every 23.minutes do
  runner "WibcFetch.fetch"
  runner "WishFetch.fetch"
  runner "WthrFetch.fetch"
  runner "TheFanFetch.fetch"
end                     

every 11.minutes do
  runner "Indystar.fetch" 
  runner "IbjFetch.fetch" 
  runner "PickyFetch.fetch"
end

every 1.hours do
  runner "FlickrFetch.fetch" 
  rake "ts:in"
end


