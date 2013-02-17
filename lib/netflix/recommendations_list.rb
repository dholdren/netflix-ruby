module Netflix
  class RecommendationsList
    include Enumerable
    MAX_RESULTS = 500

    @recommendations

    def initialize(oauth_token, user_id)
      response = oauth_token.get("/users/#{user_id}/recommendations?max_results=#{MAX_RESULTS}&output=json")
      @recommendations = JSON.parse(response.body)['recommendations']['recommendation'].map do |recommendation_hash|
        Netflix::Recommendation.new(recommendation_hash)
      end
    end

    def each(&block)
      @recommendations.each do |recommendation|
        if block_given?
          block.call recommendation
        else
          yield recommendation
        end
      end
    end

    def empty?
      @recommendations.empty?
    end
  end
end