require 'test_helper'

class ErrorTest < Test::Unit::TestCase
  def setup
    stub_netflix_for_user('nuid_one')
  end
  
  def test_handle_404_on_delete
    #add to disc queue
    FakeWeb.register_uri(:delete, %r|http://api-public\.netflix\.com/users/nuid_one/queues/disc/available|,
                         :body => '{"status": {
                           "message": "Title is not in Queue",
                           "status_code": 404,
                           "sub_code": 610
                         }}',
                         :status => ['404', 'Not Found'])
    
    user = Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user('nuid_one')
    available_disc_queue = user.available_disc_queue
    assert available_disc_queue
    assert_raises(Netflix::Error::NotFound) do
      available_disc_queue.remove(2)
    end

  end
end
  