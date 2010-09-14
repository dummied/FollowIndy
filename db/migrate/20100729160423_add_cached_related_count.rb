class AddCachedRelatedCount < ActiveRecord::Migration
  def self.up
    add_column :things, :cached_related_count, :string
  end

  def self.down
    remove_column :things, :cached_related_count
  end
end
