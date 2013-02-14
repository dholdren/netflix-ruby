$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib"))

require 'test/unit'
require 'yaml'
require 'netflix'

class QueueTest < Test::Unit::TestCase
  def setup
    @oauth_settings = YAML.load_file(File.join(File.dirname(__FILE__),"oauth_settings.yml"))
    #puts @oauth_settings
    Netflix::Client.consumer_key = @oauth_settings[:consumer_key]
    Netflix::Client.consumer_secret = @oauth_settings[:consumer_secret]
    @client = Netflix::Client.new(@oauth_settings[:user][:access_token], @oauth_settings[:user][:access_secret])
    
    #Do direct oauth gem retrieval of queue and deletion of all queue entries to get a clean start
    oauth_access_token = @client.instance_variable_get(:@oauth_access_token)
    #user_response = oauth_access_token.get "/users/current?output=json"
    #puts "current_user: #{JSON.parse(user_response.body)}"
    queue_response = oauth_access_token.get "/users/#{@oauth_settings[:user][:user_id]}/queues/disc/available?output=json"
    queue_response_json = queue_response.body
    queue_response_obj = JSON.parse(queue_response_json)
    puts "get queue response: #{queue_response_obj}"
    queue = queue_response_obj["queue"]
    queue_items = queue && queue["queue_item"] && [queue["queue_item"]].flatten
    if queue_items
      queue_item_urls = queue_items.map() {|queue_item| queue_item["id"]}
      queue_item_urls.reverse.each {|queue_item_url|
        sleep 0.25 # for netflix api queries per second limit
        response = oauth_access_token.delete queue_item_url
        puts "delete response= #{response.body}"
      }
    end
    sleep 0.25 # for netflix api queries per second limit
    @user = @client.user(@oauth_settings[:user][:user_id])
  end
  
  def test_get_available_disc_queue
    available_disc_queue = @user.available_disc_queue
    assert available_disc_queue, "Expecting user to have an available disc_queue"
  end

  def test_get_instant_disc_queue
    instant_disc_queue = @user.instant_disc_queue
    assert instant_disc_queue, "Expecting user to have an instant disc_queue"
  end
  
  def test_get_discs_add_and_remove
    sleep 0.25 # for netflix api queries per second limit
    queue = @user.available_disc_queue
    assert queue, "Expecting queue"
    assert_equal 0, queue.etag, "Initial etag should be 0 when no discs"
    discs = queue.discs
    assert discs, "Expecting the queue to respond to #discs"
    assert_equal 0, discs.size, "Expecting the discs list to have size 0 at start"

    sleep 0.25 # for netflix api queries per second limit
    queue.add("http://api.netflix.com/catalog/titles/movies/70167072")
    queue_after_add = @user.available_disc_queue
    assert_not_equal 0, queue.etag, "Etag should not be 0 after a disc is added"
    discs = queue_after_add.discs
    assert discs, "Expecting the queue to respond to #discs"
    assert_equal 1, discs.size, "Expecting the discs list to have size 1 after add"
    
    disc_one = discs[0]
    assert_equal "http://api.netflix.com/users/#{@oauth_settings[:user][:user_id]}/queues/disc/available/1/70167072", disc_one.id
    assert_equal "Arthur", disc_one.title

    sleep 0.25 # for netflix api queries per second limit
    queue.remove(1)
    sleep 0.25 # for netflix api queries per second limit
    queue_after_remove = @user.available_disc_queue
    discs = queue_after_remove.discs
    assert discs, "Expecting the queue to respond to #discs"
    assert_equal 0, discs.size, "Expecting the discs list to have size 0 after remove"
    
  end
end