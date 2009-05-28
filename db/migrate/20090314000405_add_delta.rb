class AddDelta < ActiveRecord::Migration
  def self.up  
    add_column :things, :delta, :boolean
  end

  def self.down
    remove_column :things, :delta
  end
end
