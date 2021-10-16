# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require_relative '../lib/openml_api'
require 'yaml'

DATASET_PATH = 'data/2'
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
API_KEY = CONFIG['API_KEY']
GOOD = YAML.safe_load('../spec/fixtures/dataset_result.yml')

describe 'Test OpenML api library' do
  describe 'Dataset Test' do
    it 'Should give an error on incorrect dataset path' do
      _(proc do
        MLearner::OpenMLApi.new(API_KEY).dataset('/data/-2')
      end).must_raise MLearner::OpenMLApi::Errors::NotFound
    end
  end
end
describe 'Dataset Info' do
  before do
    @dataset = MLearner::OpenMLApi.new(API_KEY).dataset(DATASET_PATH)
  end
  it 'Should return the correct name' do
    _(@dataset.name).must_equal GOOD['name']
  end

  it 'Should return the correct description' do
    _(@dataset.description).must_equal GOOD['description']
  end

  it 'Should return the correct creators' do
    _(@dataset.creator).must_equal GOOD['creator']
  end

  it 'Should return the correct original url' do
    _(@dataset.url).must_equal GOOD['url']
  end
end
