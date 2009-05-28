class AddObjects < ActiveRecord::Migration
  def self.up 
    create_table :objects, :force => true do |t|
      t.integer :external_id
      t.string  :title
      t.text    :body
      t.string  :source
      t.string  :link
      t.timestamps
    end
  end

  def self.down
    drop_table :objects
  end
end
