require 'test_helper'

class QueueTest < Test::Unit::TestCase
  def setup
    stub_netflix_for_user('nuid_one')
    stub_netflix_for_user('nuid_sub1')
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
  
  def test_add_item_to_queue_end_the_default
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    #pre tests
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/1/70167072", available_disc_queue.discs[0].id
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/2/70142826", available_disc_queue.discs[1].id
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/3/70108988", available_disc_queue.discs[2].id
    assert_equal "115673854498", available_disc_queue.etag
    #operation and tests
    new_queue = available_disc_queue.add("http://api.netflix.com/catalog/titles/movies/70071613")
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/1/70167072", new_queue.discs[0].id
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/2/70142826", new_queue.discs[1].id
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/3/70108988", new_queue.discs[2].id
    assert_equal "http://api.netflix.com/users/nuid_one/queues/disc/available/4/70071613", new_queue.discs[3].id
    assert_equal "1", new_queue.discs[0].instance_variable_get(:@map)["position"]
    assert_equal "2", new_queue.discs[1].instance_variable_get(:@map)["position"]
    assert_equal "3", new_queue.discs[2].instance_variable_get(:@map)["position"]
    assert_equal "4", new_queue.discs[3].instance_variable_get(:@map)["position"]
    assert_equal "82198468425", new_queue.etag
  end
  
  def test_add_item_to_queue_top
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_sub1')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    #pre tests
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/1/70071613", available_disc_queue.discs[0].id
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/2/70117306", available_disc_queue.discs[1].id
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/3/70105135", available_disc_queue.discs[2].id
    assert_equal "115673854498", available_disc_queue.etag
    #operation and tests
    new_queue = available_disc_queue.add("http://api.netflix.com/catalog/titles/movies/70167072", 1)
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/1/70167072", new_queue.discs[0].id
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/2/70071613", new_queue.discs[1].id
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/3/70117306", new_queue.discs[2].id
    assert_equal "http://api.netflix.com/users/nuid_sub1/queues/disc/available/4/70105135", new_queue.discs[3].id
    assert_equal "1", new_queue.discs[0].instance_variable_get(:@map)["position"]
    assert_equal "2", new_queue.discs[1].instance_variable_get(:@map)["position"]
    assert_equal "3", new_queue.discs[2].instance_variable_get(:@map)["position"]
    assert_equal "4", new_queue.discs[3].instance_variable_get(:@map)["position"]
    assert_equal "82198468425", new_queue.etag
  end
  
  def test_remove_item_from_queue_by_index
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    available_disc_queue.remove(2)
  end
  
  def test_empty_queue
    stub_netflix_for_user('empty_queue')
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('empty_queue')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue, "Expected a disc_queue"
    assert available_disc_queue.discs, "Expected the disc_queue to have a discs attribute"
    assert_equal 0, available_disc_queue.discs.size, "Expected discs to be empty array #{available_disc_queue.discs[0]}}"
    new_queue = available_disc_queue.add("http://api.netflix.com/catalog/titles/movies/70167072")
  end
  
end