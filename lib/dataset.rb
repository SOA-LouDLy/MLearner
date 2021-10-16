# frozen_string_literal: true

require 'http'

module MLearner
  # Library for OpenML Web API
  class Dataset
    def initialize(data)
      @dataset = data
    end

    def creator
      @dataset['creator']
    end

    def url
      @dataset['url']
    end

    def description
      @dataset['description']
    end

    def name
      @dataset['name']
    end
  end
end
