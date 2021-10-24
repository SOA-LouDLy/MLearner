# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'dataset'

module MLearner
  # Library for OpenML Web API
  class OpenMLApi
    API_ROOT = 'https://www.openml.org/api/v1/json/'

    def initialize(api_key)
      @api_key = api_key
    end

    def dataset(path)
      dataset = JSON.parse(Request.new(API_ROOT, @api_key).dataset(path).body.to_s)
      Dataset.new(dataset)
    end

    # Sends Request to openML for Datasets
    class Request
      def initialize(api_root, key)
        @api_root = api_root
        @key = key
      end

      def dataset(path)
        get("#{@api_root}#{path}?api_key=#{@key}")
      end

      def get(url)
        http_response = HTTP.get(url)
        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end
    end

    # Decorates HTTP responses with success/error
    class Response < SimpleDelegator
      # We are trying to retrieve data that we don't have authorization for.
      Unauthorized = Class.new(StandardError)
      # The entered data is not found on the server.
      NotFound = Class.new(StandardError)

      HTTP_ERROR = {
        401 => Unauthorized,
        404 => NotFound,
        412 => NotFound
      }.freeze

      def successful?
        !HTTP_ERROR.keys.include?(code)
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
