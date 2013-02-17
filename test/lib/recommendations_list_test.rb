require File.dirname(File.realdirpath(__FILE__)) + '/../test_helper.rb'

describe Netflix::RecommendationsList do
  let(:user_id) { 'user_id' }
  let(:oauth_double) { MiniTest::Mock.new }
  let(:oauth_response) { OpenStruct.new(:body => File.open(
    File.join(File.dirname(__FILE__), '..', 'http_fixtures', 'netflix_recommendations_list_response.json')
  ).read) }
  let(:url_matcher) do
    ->(url) do
      regexp = %r|users/#{user_id}/recommendations|
      url.match(regexp)
    end
  end

  before { oauth_double.expect(:get, oauth_response, [url_matcher]) }

  describe 'initialization' do
    it 'retrieves recommendations for the user' do
      Netflix::RecommendationsList.new(oauth_double, user_id)

      oauth_double.verify
    end

    it 'populates recommendations from the Netflix response' do
      oauth_double.expect(:get, oauth_response, [String])

      recommendations = Netflix::RecommendationsList.new(oauth_double, user_id)
      recommendations.first.short_title.must_equal('The Sopranos')
    end
  end

  describe '#empty?' do
    let(:url_matcher) {String}
    context 'when the list has no elements' do
      let(:oauth_response) { OpenStruct.new(:body => File.open(
          File.join(File.dirname(__FILE__), '..', 'http_fixtures', 'netflix_empty_recommendations_list_response.json')
        ).read) }
      it 'is true' do
        Netflix::RecommendationsList.new(oauth_double, user_id).must_be_empty
      end
    end

    context 'when the list has elements' do
      it 'is false' do
        Netflix::RecommendationsList.new(oauth_double, user_id).wont_be_empty
      end
    end
  end
end