require 'test_helper'

class NonUserClientTest < Test::Unit::TestCase
  def setup
    stub_netflix_for_user('nuid_one')
    Netflix::Client.consumer_key = 'foo_consumer_key'
    Netflix::Client.consumer_secret = 'foo_consumer_secret'
  end
  
  def test_client
    @client = Netflix::Client.new()
  end
  
  #TODO
  #def test_retrieve_catalog_item
  #  @client = Netflix::Client.new()
  #  catalog_results = @client.catalog_find('Mars Attacks')
  #  catalog_title = catalog_results[0]
  #end
end