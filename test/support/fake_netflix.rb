class FakeNetflix
  def self.stub_netflix_for_user(netflix_user_id)
    @netflix_user_responses ||= YAML.load_file(File.join(File.dirname(__FILE__), '..', 'http_fixtures', 'netflix_user_responses.yml'))
    @netflix_queue_responses ||= YAML.load_file(File.join(File.dirname(__FILE__), '..', 'http_fixtures', 'netflix_queue_responses.yml'))
    @netflix_recommendation_response ||= File.open(File.join(File.dirname(__FILE__), '..', 'http_fixtures', 'netflix_recommendations_list_response.json')).read
    @empty_netflix_recommendation_response ||= File.open(File.join(File.dirname(__FILE__), '..', 'http_fixtures', 'netflix_empty_recommendations_list_response.json')).read

    WebMock.disable_net_connect!

    WebMock.stub_request(
      :get, "http://api-public.netflix.com/users/#{netflix_user_id}?output=json"
    ).to_return(
      :body => @netflix_user_responses[netflix_user_id]['get']['body']
    )

    WebMock.stub_request(
      :get, %r|http://api-public\.netflix\.com/users/#{netflix_user_id}/queues/disc.*|
    ).to_return(
      :body => @netflix_queue_responses[netflix_user_id]['get']['body']
    )

    WebMock.stub_request(
      :post, %r|http://api-public\.netflix\.com/users/#{netflix_user_id}/queues/disc|
    ).to_return(
      :body => @netflix_queue_responses[netflix_user_id]['post']['body']
    )

    WebMock.stub_request(
      :get, %r|http://api-public\.netflix\.com/users/#{netflix_user_id}/recommendations|
    ).to_return(
      :body => @netflix_recommendation_response
    )
  end
end