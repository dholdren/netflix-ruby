require 'test_helper'

class QueueTest < Test::Unit::TestCase
  def setup
    stub_netflix_for_user('nuid_one')
    Netflix::Client.consumer_key = 'foo_consumer_key'
    Netflix::Client.consumer_secret = 'foo_consumer_secret'
  end
  
  def test_get_available_disc_queue
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
  end
  
  def test_get_discs
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    discs = available_disc_queue.discs
    assert discs
    assert_equal 3, discs.size
    disc_one = discs[0]
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/1/70167072", disc_one.id
    assert_equal "Arthur", disc_one.title
  end
  
  def test_add_item_to_queue
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    available_disc_queue.add('70071613')
  end
  
  def test_add_item_to_queue_top
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    available_disc_queue.add('70071613', 1)
  end
  
  def test_remove_item_from_queue_by_index
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    available_disc_queue.remove(2)
  end
  
  #def test_add_item_to_stale_queue_fails
  #  user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
  #  available_disc_queue = user.available_disc_queue
  #  assert available_disc_queue
  #  available_disc_queue.add('70071613')
  #  old_available_disc_queue = available_disc_queue
  #  
  #  available_disc_queue = user.available_disc_queue
  #  available_disc_queue.add('70117306')
  #  
  #  assert_raises() {
  #    old_available_disc_queue.add('70105135')
  #  }
  #end
  
  
end