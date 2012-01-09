require 'test_helper'

class UserTest < Test::Unit::TestCase
  def setup
    stub_netflix_for_user('nuid_one')
    Netflix::Client.consumer_key = 'foo_consumer_key'
    Netflix::Client.consumer_secret = 'foo_consumer_secret'
  end
  
  def test_user_client
    client = Netflix::Client.new('nuid_access_key', 'nuid_access_secret')
    
  end
  
  def test_retrieve_user
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    assert_equal "Jane", user.first_name
    assert_equal "Smith", user.last_name
    assert_equal true, user.can_instant_watch
    assert_equal "foobar", user.nickname
    assert_equal "nuid_one", user.user_id
  end
  
  def test_retrieve_subaccount
    stub_netflix_for_user('nuid_sub1')
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_sub1')
    assert_equal "John", user.first_name
    assert_equal "Smith", user.last_name
    assert_equal false, user.can_instant_watch
    assert_equal "foobar", user.nickname
    assert_equal "nuid_sub1", user.user_id
  end
end