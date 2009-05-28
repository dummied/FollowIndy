class HashTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :type, :string
  end

  def self.down
    remove_column :tags, :type
  end
end
