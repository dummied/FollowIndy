class AddExternalDataBlob < ActiveRecord::Migration
  def self.up
    add_column :things, :external_data, :text
  end

  def self.down
    remove_column :things, :external_data
  end
end
