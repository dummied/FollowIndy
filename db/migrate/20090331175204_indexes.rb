class Indexes < ActiveRecord::Migration
  def self.up
    add_index :taggings, :taggable_id
    add_index :taggings, :taggable_type
  end

  def self.down
  end
end
