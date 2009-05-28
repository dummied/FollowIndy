class Indexes3 < ActiveRecord::Migration
  def self.up 
    add_index :things, :source
  end

  def self.down
  end
end
