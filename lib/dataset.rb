# frozen_string_literal: true

require 'http'

module MLearner
  # Library for OpenML Web API
  class Dataset
    def initialize(data)
      @dataset = data
    end

    def creator
      @dataset['data_set_description']['creator']
    end

    def url
      @dataset['data_set_description']['url']
    end

    def description
      @dataset['data_set_description']['description']
    end

    def name
      @dataset['data_set_description']['name']
    end
  end
end
