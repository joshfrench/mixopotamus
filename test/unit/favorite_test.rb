require File.dirname(__FILE__) + '/../test_helper'

class FavoriteTest < Test::Unit::TestCase
  fixtures :favorites, :users, :swapsets
  
  def test_should_give_favorite
    @aaron = users(:aaron)
    @quentin = users(:quentin)
    @alligator = swapsets(:alligator)
    @alligator.assign @aaron
    
    assert_difference(Favorite, :count, 1) do
      assert Favorite.create(:from => @quentin, :to => @aaron, :swapset => @alligator)
    end
    assert_equal 1, @quentin.favorites.size
    assert_equal 1, @aaron.stars.size
    
    assert_equal 1, @quentin.stars.size # quentin already has a star in the fixtures, make sure he doesn't get another
    assert_equal 1, @aaron.favorites.size # ...aaron gave it to him; same deal
  end
  
  def test_to_user
    assert_equal favorites(:aaron_to_quentin).to_user, users(:quentin)
  end
  
end
