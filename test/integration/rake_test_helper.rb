require 'oauth'
require 'launchy'

class IntegrationTestHelper
  def self.obtain_credentials
    puts "Enter Consumer Key/Secret info before running integration tests, you should have registered with http://developer.netflix.com"
    printf "Consumer Key:"
    consumer_key = STDIN.gets.chomp
    printf "Consumer Secret:"
    consumer_secret = STDIN. gets.chomp
    printf "Do you have an access token/secret? ([Y]/n)"
    answer = STDIN.gets.chomp
    if ["N","n","No","no"].include?(answer)
      puts "Launching netflix oauth page, login to TEST account and allow this application"
      oauth_consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
        :site => "http://api.netflix.com", 
        :request_token_url => "http://api-public.netflix.com/oauth/request_token", 
        :access_token_url => "http://api-public.netflix.com/oauth/access_token", 
        :authorize_url => "https://api-user.netflix.com/oauth/login")
      request_token = oauth_consumer.get_request_token
      authorize_url = request_token.authorize_url(:oauth_consumer_key => consumer_key)
      Launchy.open(authorize_url)
      puts "Go to browser, a page has been opened to establish oauth"
      printf "Pin from Netflix:"
      pin = STDIN.gets.chomp
      access_token_response = request_token.get_access_token(:oauth_verifier => pin)
      access_token = access_token_response.token
      access_secret = access_token_response.secret
      user_id = access_token_response.params["user_id"]
    else
      printf "Access Token:"
      access_token = STDIN.gets.chomp
      printf "Access Secret:"
      access_secret = STDIN.gets.chomp
      printf "User id:"
      user_id = STDIN.gets.chomp
    end
    
    {:consumer_key => consumer_key, :consumer_secret => consumer_secret, :user => {:access_token => access_token, :access_secret => access_secret, :user_id => user_id}}
    
  end
end