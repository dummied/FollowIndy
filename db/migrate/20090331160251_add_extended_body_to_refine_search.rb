class AddExtendedBodyToRefineSearch < ActiveRecord::Migration
  def self.up  
    add_column :things, :extended_body, :text
  end

  def self.down
    remove_column :things, :extended_body
  end
end
