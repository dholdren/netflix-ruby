require 'netflix/json_resource'

module Netflix
  class Queue < JsonResource
    TYPE_DISC = "disc"
    TYPE_INSTANT = "instant"
    MAX_RESULTS = 500
    
    define_getter :etag, :queue_item
    
    def initialize(oauth_access_token, user_id, type=TYPE_DISC, options={})
      @oauth_access_token = oauth_access_token
      @user_id = user_id
      @type = type
      @options = options.merge(:etag => nil)
      super(retrieve(@options))
    end
    
    #def queue_items
    #  queue_items = [queue_item].flatten
    #  queue_items.map {|queue_item| Disc.new(queue_item)}
    #end
    
    def add(title_ref, position=nil)
      response = @oauth_access_token.post "/users/#{@user_id}/queues/#{@type}?output=json", {:etag => etag, :title_ref => title_ref, :position=> position}
      #@map = retrieve
      #netflix is wacky. GET after an add can be STALE. ughg
      #so recreate the contents programattically instead
      response_obj = JSON.parse(response.body)
      new_queue_item = response_obj["status"]["resources_created"]["queue_item"]
      new_etag = response_obj["status"]["etag"]
      repopulate(new_queue_item, new_etag)
      self
    end
    
    def remove(position)
      id = discs[position-1].id
      #response = @oauth_access_token.delete "/users/#{@user_id}/queues/#{@type}/available/#{position}?output=json" , {'etag' => etag}
      response = @oauth_access_token.delete "#{id}?output=json"
      @map = retrieve
      self
    end
    
    def remove_by_title_ref(title_ref)
      disc = discs.find {|disc| disc =~ /\/#{title_ref}\//}
      response = @oauth_access_token.delete "#{disc.id}?output=json"
      @map = retrieve
      self
    end
    
    def discs
      if queue_item
        queue_items = [queue_item].flatten
        queue_items.map {|queue_item| Disc.new(queue_item)}
      else
        []
      end
    end
    
    def refresh
      @map = retrieve(@options.merge(:tag => etag))
      self
    end
    
    private
    def retrieve(options = {})
      @expanded    = "&expand=#{options[:include].join(',')}" if options[:include]
      @max_results = options[:max_results] ? options[:max_results] : MAX_RESULTS

      url = "/users/#{@user_id}/queues/#{@type}/available?max_results=#{@max_results}&output=json#{@expanded}"
      puts url

      if (options[:etag])
        response = @oauth_access_token.get(url, { 'etag' => options[:etag].to_s })
      else
        response = @oauth_access_token.get(url)
      end
      JSON.parse(response.body)["queue"]
    end
    
    def repopulate(new_queue_item, new_etag)
      @map["etag"] = new_etag
      new_queue_item_index = new_queue_item["position"].to_i
      if @map["queue_item"] #single or array
        @map["queue_item"] = [@map["queue_item"]].flatten
        @map["queue_item"].insert((new_queue_item_index - 1), new_queue_item)
        @map["queue_item"][new_queue_item_index..-1].each {|queue_item| 
          new_position = (queue_item["position"].to_i + 1).to_s
          queue_item["position"] = new_position
          queue_item["id"] = queue_item["id"].gsub(/\/(\d+)\/(\d+)/,"/#{new_position}/\\2")
        }
      else
        @map["queue_item"] = [new_queue_item]
      end
    end
  
  end
end