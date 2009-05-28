class ChangeObjectName < ActiveRecord::Migration
  def self.up
    rename_table :objects, :things
  end

  def self.down
    rename_table :things, :objects
  end
end
