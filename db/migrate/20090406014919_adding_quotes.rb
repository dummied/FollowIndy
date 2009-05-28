class AddingQuotes < ActiveRecord::Migration
  def self.up   
    create_table :quotes, :force => true do |t|
      t.text    :body
      t.string  :quoted
      t.integer :thing_id
      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
