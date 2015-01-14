$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require 'test/unit'
require 'yaml'
require 'fakeweb'
require 'netflix'

class Test::Unit::TestCase
  def stub_netflix_for_user(netflix_user_id)
    @netflix_user_responses ||= YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "http_fixtures", "netflix_user_responses.yml")))
    @netflix_queue_responses ||= YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "http_fixtures", "netflix_queue_responses.yml")))
    
    FakeWeb.allow_net_connect = false
    
    #override specific REST actions
    #GET user
    FakeWeb.register_uri(:get, "http://api-public.netflix.com/users/#{netflix_user_id}?output=json", 
                         :body => @netflix_user_responses[netflix_user_id]['get']['body'])
    #GET disc queue
    FakeWeb.register_uri(:get, %r|http://api-public\.netflix\.com/users/#{netflix_user_id}/queues/disc.*|, 
                         :body => @netflix_queue_responses[netflix_user_id]['get']['body'])
    #add to disc queue
    FakeWeb.register_uri(:post, %r|http://api-public\.netflix\.com/users/#{netflix_user_id}/queues/disc|, 
                         :body => @netflix_queue_responses[netflix_user_id]['post']['body'])
    #remove from disc queue
    FakeWeb.register_uri(:delete, %r|http://api-public\.netflix\.com/users/#{netflix_user_id}/queues/disc/available|, 
                         :body => @netflix_queue_responses[netflix_user_id]['delete']['body'])

  end
end