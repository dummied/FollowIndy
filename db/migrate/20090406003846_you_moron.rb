class YouMoron < ActiveRecord::Migration
  def self.up  
    rename_column :tags, :type, :special_type
  end

  def self.down
    rename_column :tags, :special_type, :type
  end
end
