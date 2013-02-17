require File.dirname(File.realdirpath(__FILE__)) + '/../test_helper.rb'

describe Netflix::Recommendation do
  let(:user_id) { 'user_id' }
  let(:oauth_double) { MiniTest::Mock.new }

  describe 'initialization' do
    let(:source_hash) do
      {
        'average_rating' => :average_rating,
        'predicted_rating' =>  :predicted_rating,
        'title' => {
          'regular' => :regular_title,
          'short' => :short_title,
        },
        'category' =>  [
          {
            'label' => :other,
            'scheme' => 'http://api-public.netflix.com/categories/tv_ratings'
          },
          {
            'label' => :genre_1,
            'scheme' => 'http://api-public.netflix.com/categories/genres'
          },
          {
            'label' => :genre_2,
            'scheme' => 'http://api-public.netflix.com/categories/genres'
          }
        ]
      }
    end
    
    it 'sets the instance variables' do
      rec = Netflix::Recommendation.new(source_hash)
      rec.average_rating.must_equal(:average_rating)
      rec.predicted_rating.must_equal(:predicted_rating)
      rec.regular_title.must_equal(:regular_title)
      rec.short_title.must_equal(:short_title)
      rec.genres.must_equal([:genre_1, :genre_2])
    end
  end
end