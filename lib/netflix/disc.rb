require 'netflix/json_resource'

module Netflix
  class Disc < JsonResource
    define_getter :id, :updated
    
    def title
      @map["title"]["regular"]
    end
  end
end