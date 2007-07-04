require File.dirname(__FILE__) + '/../test_helper'

class SwapsetTest < Test::Unit::TestCase
  fixtures :swapsets, :users

  def setup
    @alligator = swapsets(:alligator)
    @quentin = users(:quentin)
    @aaron = users(:aaron)
  end

  def test_should_add_users
    assert_difference(@alligator.users, :count, 1) do
      @alligator.assign @aaron
    end
    assert @alligator.users.include?(@aaron)
    assert @aaron.swapsets.include?(@alligator)
  end
  
  def test_should_not_add_duplicate_users
    assert_difference(@alligator.users, :count, 0) do
      @alligator.assign @quentin
    end
  end
  
end
