# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require_relative '../lib/openml_api'

DATASET_PATH = 'data/2'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
API_KEY= CONFIG['API_KEY']
GOOD = YAML.safe_load(File.read('spec/fixtures/oml_results.yml'))
CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'openml_api'
