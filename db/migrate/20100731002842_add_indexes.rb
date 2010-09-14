class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :things, :source_id
    add_index :feeds, :source_id
    add_index :sources, :home_url
    add_index :sources, :slug
  end

  def self.down
    remove_index :sources, :slug
    remove_index :sources, :home_url
    remove_index :feeds, :source_id
    remove_index :things, :source_id
  end
end
