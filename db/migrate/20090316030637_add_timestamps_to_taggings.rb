class AddTimestampsToTaggings < ActiveRecord::Migration
  def self.up  
    add_column :taggings, :created_at, :datetime
  end

  def self.down
    remove_column :taggings, :created_at
  end
end
