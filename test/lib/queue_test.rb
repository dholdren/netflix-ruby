require File.dirname(File.realdirpath(__FILE__)) + '/../test_helper.rb'

describe Netflix::Queue do
  before do
    FakeNetflix.stub_netflix_for_user(user_id)
    Netflix::Client.consumer_key = 'foo_consumer_key'
    Netflix::Client.consumer_secret = 'foo_consumer_secret'
  end

  let(:user_id) { 'nuid_one' }
  let(:queue) { Netflix::Client.new('nuid_access_key', 'nuid_access_secret').user(user_id).available_disc_queue }

  describe '#discs' do
    it 'returns an Array of discs' do
      queue.discs.wont_be_empty
      queue.discs.all? { |disc| disc.is_a?(Netflix::Disc).must_equal(true) }
    end

    it 'returns the correct discs' do
      queue.discs.first.id.must_equal('http://api-public.netflix.com/users/nuid_one/queues/disc/available/1/70167072')
    end
  end

  describe '#add' do
    let(:new_movie_id) { '70071613' }
    let(:new_disc_url) { "http://api-public.netflix.com/catalog/titles/movies/#{new_movie_id}" }

    context 'without a position parameter' do
      it 'enqueues the disc' do
        queue.discs.size.must_equal(3)

        new_queue = queue.add(new_disc_url)

        new_queue.discs.size.must_equal(4)
        new_queue.discs[3].id.must_match(%r|#{new_movie_id}$|)
      end

      it 'updates the etag' do
        queue.etag.must_equal('115673854498')

        new_queue = queue.add(new_disc_url)

        new_queue.etag.must_equal('82198468425')
      end
    end

    context 'with a position parameter' do
      let(:user_id) { 'nuid_sub1' }
      let(:new_movie_id) { '70167072' }

      it 'places the new disc at the given position' do
        queue.discs.size.must_equal(3)

        new_queue = queue.add(new_disc_url, 1)

        new_queue.discs.size.must_equal(4)
        new_queue.discs[0].id.must_match(%r|#{new_movie_id}$|)
      end
    end
  end

  describe '#remove' do
    it 'makes the request to remove the disc' do
      disc_for_removal_id = queue.discs[1].id
      delete_stub = stub_request(:delete, %r{#{disc_for_removal_id}.*})

      queue.remove(2)

      assert_requested(delete_stub)
    end

    context 'when the item to remove ist not in the list' do
      let(:response_body) {
        <<-JSON
        {"status": {
           "message": "Title is not in Queue",
           "status_code": 404,
           "sub_code": 610
          }
        }
        JSON
      }
      let(:request_url) { %r|http://api-public\.netflix\.com/users/nuid_one/queues/disc/available| }

      before do
        WebMock.stub_request(:delete, request_url).to_return(:body => response_body, :status => ['404', 'Not Found'])
      end

      it 'does not raise an exception' do
        Proc.new do
          queue.remove(2)
        end.must_raise(Netflix::Error::NotFound)
      end
    end
  end
end