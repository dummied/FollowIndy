class Indexes4 < ActiveRecord::Migration
  def self.up
    add_index :things, :created_at
  end

  def self.down
  end
end
