module Netflix
  class Recommendation
    attr_reader :average_rating, :predicted_rating, :regular_title, :short_title, :genres

    def initialize(source_hash)
      @average_rating = source_hash['average_rating']
      @predicted_rating = source_hash['predicted_rating']
      @regular_title = source_hash['title']['regular']
      @short_title = source_hash['title']['short']
      @genres = genres_from_source(source_hash)
    end

    private

    def genres_from_source(source_hash)
      source_hash['category'].select do |category|
        category['scheme'] == 'http://api-public.netflix.com/categories/genres'
      end.map { |category| category['label'] }
    end
  end
end