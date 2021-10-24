# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests OpenML API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<API_KEY>') { API_KEY }
    c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(API_KEY) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Dataset Information' do

    it 'SAD: should raise exception on incorrect path' do
      _(proc do
        MLearner::OpenMLApi.new(API_KEY).dataset('data/-2')
      end).must_raise MLearner::OpenMLApi::Response::NotFound
    end
  end

  describe 'Dataset info' do
    before do
      @dataset = MLearner::OpenMLApi.new(API_KEY).dataset(DATASET_PATH)
    end

    it 'HAPPY: should return the correct creator ' do
     _(@dataset.creator).must_equal GOOD['creator']
    end

    it 'HAPPY: should return the correct url ' do
      _(@dataset.url).must_equal GOOD['url']
    end
    it 'HAPPY: should return the correct description ' do
      _(@dataset.description).must_equal GOOD['description']
    end
    it 'HAPPY: should return the correct name' do
      _(@dataset.name).must_equal GOOD['name']
    end
  end
end
