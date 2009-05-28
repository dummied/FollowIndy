require 'test_helper'

class ThingTest < ActiveSupport::TestCase
  context "A Thing instance" do
    setup do
      @thing = Thing.new 
    end
    
    should_have_many :tags, :through => :taggings
  
    should "respond_to #title" do
      assert @thing.respond_to?(:title)
    end 

    should "respond_to #source" do
      assert @thing.respond_to?(:source)
    end    
    
    should "respond_to #link" do
      assert @thing.respond_to?(:link)
    end  
    
    should "respond_to #tags" do
      assert @thing.respond_to?(:tags)
    end 
    
    should "respond_to #external_id" do
      assert @thing.respond_to?(:external_id)
    end
    
    should "respond_to #body" do
      assert @thing.respond_to?(:body)
    end
    
    
  end
end