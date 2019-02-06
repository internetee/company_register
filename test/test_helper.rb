require 'simplecov' if ENV['COVERAGE']

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'company_register'

require 'minitest/autorun'
