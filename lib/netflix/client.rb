require 'oauth'

module Netflix
  class Client
    class << self
      attr_accessor :consumer_key, :consumer_secret, :app_name
    end
    
    #attr_accessor :oauth_consumer, :oauth_access_token
    
    def initialize(user_access_token=nil, user_access_secret=nil)
      @oauth_consumer = OAuth::Consumer.new(Client.consumer_key, Client.consumer_secret,
        :site => "http://api.netflix.com", 
        :request_token_url => "http://api.netflix.com/oauth/request_token", 
        :access_token_url => "http://api.netflix.com/oauth/access_token", 
        :authorize_url => "https://api-user.netflix.com/oauth/login")
      if user_access_token && user_access_secret
        @oauth_access_token = oauth_access_token(user_access_token, user_access_secret)
        #automatically determine if error should be thrown based on response codes
        @oauth_access_token.extend(ResponseErrorDecorator)
      elsif !!user_access_token ^ !!user_access_secret
        raise ArgumentError 'Must specify both user_access_token and user_access_secret if specifying either'
      end
    end
    
    def user(user_id)
      if @oauth_access_token
        @user ||= User.new(@oauth_access_token, user_id)
      else
        raise "Must instantiate client with user auth token/secret"
      end
    end
    
    #launches the Netflix OAuth page, and asks for the pin
    #this is interactive (i.e. irb or commandline)
    def oauth
      request_token = @oauth_consumer.get_request_token
      authorize_url = request_token.authorize_url(:oauth_consumer_key => 
        Netflix::Client.consumer_key)
      Launchy.open(authorize_url)
      puts "Go to browser, a page has been opened to establish oauth"
      printf "Pin from Netflix:"
      pin = gets.chomp
      access_token = request_token.get_access_token(:oauth_verifier => pin)
    end
    
    def oauth_via_callback(callback_url)
      request_token = @oauth_consumer.get_request_token(:oauth_callback => 
        callback_url, :application_name => Netflix::Client.app_name)
      authorize_url = request_token.authorize_url(:oauth_consumer_key => 
        Netflix::Client.consumer_key)
      [request_token, authorize_url]
    end
    
    def handle_oauth_callback(request_token, oauth_verifier)
      access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
    end
    
    private
    def oauth_access_token(user_access_token, user_access_secret)
      OAuth::AccessToken.new(@oauth_consumer, user_access_token, user_access_secret)
    end
  end
end