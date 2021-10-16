# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'dataset'

module MLearner
  # Library for OpenML Web API
  class OpenMLApi
    API_PROJECT_ROOT = 'https://www.openml.org/api/v1/json/'

    module Errors
      # The entered data is not found on the server.
      class NotFound < StandardError; end
      # We are trying to retrieve data that we don't have authorization for.
      class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound,
      412 => Errors::NotFound
    }.freeze

    def initialize(api_key)
      @api_key = api_key
    end

    def dataset(path)
      data = get_data(path)
      # dataset = retrieve_dataset(data).parse
      dataset = JSON.parse(retrieve_dataset(data).body.to_s)
      Dataset.new(dataset)
    end

    private

    def get_data(path)
      "#{API_PROJECT_ROOT}/#{path}?api_key=#{@api_key}"
    end

    def retrieve_dataset(url)
      result = HTTP.get(url)

      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
