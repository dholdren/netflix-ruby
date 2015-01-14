require 'netflix/json_resource'

module Netflix
  class Disc < JsonResource
    define_getter :id, :updated, :boxart, :release_year, :position, :average_rating
    
    def title
      @map["title"]["regular"]
    end

    def genres
      @genres ||= @map["category"].map{|c|c["term"] if c["scheme"].eql?('http://api-public.netflix.com/categories/genres')}.compact
    end

    def rating
      @genres ||= @map["category"].select{|c|c["scheme"].eql?('http://api-public.netflix.com/categories/mpaa_ratings')}.first["term"]
    end

  end
end