require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :things  
  def setup
    @obj = Thing.find(:first)
    @obj.tag_with "pale imperial"
  end

  def test_to_s
    assert_equal "imperial pale", Thing.find(:first).tags.to_s
  end
  
end
