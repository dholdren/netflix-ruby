# *ATTENTION*: NETFLIX HAS CLOSED THE PUBLIC API. ALL FURTHER DEVELOPMENT ON THIS GEM HAS CEASED

# Netflix API for Ruby
Copyright (c) 2012 Dean Holdren

To install: `gem install netflix`

This gem uses Netflix's OAuth REST API, you first need to register an application with Netflix at http://developer.netflix.com/apps/register/

This will provide you with a "consumer key", "consumer secret", and "application name"

### To use authenticated features (i.e. queue management):
* Set the consumer/developer config:
  ```ruby
  Netflix::Client.consumer_key = <your consumer/developer key>
  Netflix::Client.consumer_secret = <your consumer/developer secret>
  ```

* Do OAuth dance: (This is a one-time per user step, save the result somewhere.)
  1. Interactive (commandline/irb):  
    This will open a netflix.com web page to ask the user to authenticate, and provide a pin.
    ```ruby
    access_token = Netflix::Client.new.oauth
    ```

  2. or Web application (Rails/Sinatra/etc), define a URL that can handle the callback
    ```ruby
    request_token, auth_url = Netflix::Client.new.oauth_via_callback(my_callback_url)
    session[:request_token] = request_token
    redirect_to auth_url
    ```

    Then in the handler for "my_callback_url" (i.e. a Rails controller action) retrieve the :oauth_verifier out of the request params
    ```ruby
    oauth_verifier = params[:oauth_verifier]
    request_token = session[:request_token]
    access_token = Netflix::Client.new.handle_oauth_callback(request_token, oauth_verifier)
    ```
  

* After OAuth credentials are established:
  ```ruby
  access_token = access_token.token
  access_secret = access_token.secret
  user_id = access_token.params["user_id"]
  ```
  
(Record these, for example in a User table in a database)
  ```ruby
  client = Netflix::Client.new(access_token, access_token_secret)
  user = client.user(user_id)
  queue = user.available_disc_queue
  discs = queue.discs
  disc_one = discs[0]
  puts "#{disc_one.title} #{disc_one.id}"
  queue.remove(1) #queue is 1-based, so this is first disc
  ```

### TODO
  * unauthenticated features (catalog search)

### Credits
This work is based on: REST API documentation of Netflix (http://developer.netflix.com),
with some help from twitter gem for OAuth ideas https://github.com/jnunemaker/twitter/
  
  
