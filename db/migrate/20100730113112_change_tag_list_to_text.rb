class ChangeTagListToText < ActiveRecord::Migration
  def self.up
    change_column :things, :tag_list, :text
  end

  def self.down
    change_column :things, :tag_list, :string
  end
end
