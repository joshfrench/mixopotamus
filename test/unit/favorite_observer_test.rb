require File.dirname(__FILE__) + '/../test_helper'

class FavoriteObserverTest < Test::Unit::TestCase
  fixtures :favorites, :users, :assignments, :confirmations
  
  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
  end
  
  def test_add_confirm_with_favorite
    @assignment = confirmations(:aaron_to_quentin).assignment
    confirmations(:aaron_to_quentin).destroy
    assert_equal 0, Confirmation.count
    assert_difference Confirmation, :count, 1 do
      @aaron.favorite @assignment
    end    
    assert @aaron.favorited?(@assignment)
  end
  
  def test_dont_add_confirm_when_already_confirmed
    @assignment = favorites(:aaron_to_quentin).assignment
    favorites(:aaron_to_quentin).destroy
    assert_equal 0, Favorite.count
    assert_no_difference Confirmation, :count do
      @aaron.favorite @assignment
    end
  end
  
end
