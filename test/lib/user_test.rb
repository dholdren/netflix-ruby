require (File.dirname(File.realdirpath(__FILE__)) + '/../test_helper.rb')

describe Netflix::User do
  before do
    Netflix::Client.consumer_key = 'foo_consumer_key'
    Netflix::Client.consumer_secret = 'foo_consumer_secret'
    FakeNetflix.stub_netflix_for_user(user_id)
  end

  let(:user_id) { 'nuid_one' }
  let(:client) { Netflix::Client.new('nuid_access_key', 'nuid_access_secret') }

  describe 'initialization' do
    context 'retrieving the main user' do
      it 'populates the user attributes' do
        user = client.user('nuid_one')
        user.first_name.must_equal('Jane')
        user.last_name.must_equal('Smith')
        user.can_instant_watch.must_equal(true)
        user.nickname.must_equal('foobar')
        user.user_id.must_equal(user_id)
      end
    end

    context 'retrieving a sub user' do
      let(:user_id) { 'nuid_sub1' }

      it 'populates the user attributes' do
        user = client.user(user_id)
        user.first_name.must_equal('John')
        user.user_id.must_equal(user_id)
      end
    end
  end

  describe '#available_disc_queue' do
    it 'returns a Netflix queue' do
      user = client.user('nuid_one')
      available_disc_queue = user.available_disc_queue
      available_disc_queue.must_be_instance_of(Netflix::Queue)
    end
  end
end