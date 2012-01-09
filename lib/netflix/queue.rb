require 'netflix/json_resource'

module Netflix
  class Queue < JsonResource
    TYPE_DISC = "disc"
    TYPE_INSTANT = "instant"
    MAX_RESULTS = 500
    
    define_getter :etag, :queue_item
    
    def initialize(oauth_access_token, user_id, type=TYPE_DISC)
      @oauth_access_token = oauth_access_token
      @user_id = user_id
      @type = type
      super(retrieve)
    end
    
    #def queue_items
    #  queue_items = [queue_item].flatten
    #  queue_items.map {|queue_item| Disc.new(queue_item)}
    #end
    
    def add(title_ref, position=nil)
      response = @oauth_access_token.post "/users/#{@user_id}/queues/#{@type}?output=json", {:etag => etag, :title_ref => title_ref, :position=> position}
      if response && response.code_type == Net::HTTPOK
        #TODO refresh
      else
        raise "Error adding title #{title_ref} to user #{@user_id}"
      end
    end
    
    def remove(position)
      response = @oauth_access_token.delete "/users/#{@user_id}/queues/#{@type}/available/#{position}?output=json" #, {:etag => etag})
      if response && response.code_type == Net::HTTPOK
        #TODO refresh
      else
        raise "Error removing title #{title_ref} to user #{@user_id}"
      end
    end
    
    def discs
      queue_items = [queue_item].flatten
      queue_items.map {|queue_item| Disc.new(queue_item)}
    end
    
    private
    def retrieve
      response = @oauth_access_token.get "/users/#{@user_id}/queues/#{@type}?max_results=#{MAX_RESULTS}&output=json"
      if response && response.body && response.code_type == Net::HTTPOK
        JSON.parse(response.body)["queue"]
      else
        raise "Error retrieving queue for user #{@user_id}"
      end
    end
  
  end
end