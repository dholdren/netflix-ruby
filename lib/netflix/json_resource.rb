require 'json'

module Netflix
  class JsonResource
    class << self
      def define_getter(*symbols)
        symbols.each do |symbol|
          define_method symbol do
            @map[symbol.to_s]
          end
        end
      end
    end
  
    def initialize(map)
      @map = map
    end
  end
end