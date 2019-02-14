require 'test_helper'
require 'active_support/core_ext/integer/time'
require 'ostruct'

class ConfigurationTest < Minitest::Test
  def teardown
    CompanyRegister.configuration = nil
  end

  def test_configures_gem
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
      config.cache_store = 'some store'
      config.cache_period = 1
    end

    assert_equal 'john', CompanyRegister.configuration.username
    assert_equal 'pwd', CompanyRegister.configuration.password
    assert_equal 'some store', CompanyRegister.configuration.cache_store
    assert_equal 1, CompanyRegister.configuration.cache_period

    CompanyRegister.configuration = nil
  end

  def test_sets_valid_cache_period
    CompanyRegister.configure do |config|
      config.cache_period = 1.minute
    end
    assert_equal 1.minute, CompanyRegister.configuration.cache_period
  end

  def test_disallows_invalid_cache_period
    e = assert_raises(ArgumentError) do
      CompanyRegister.configure do |config|
        config.cache_period = 1
      end
    end
    assert_equal 'Instance of ActiveSupport::Duration is expected', e.message
  end

  def test_sets_default_cache_store_when_used_with_rails
    Object.const_set('Rails', OpenStruct.new(cache: 'rails-cache-store'))
    CompanyRegister.configure {}
    assert_equal 'rails-cache-store', CompanyRegister.configuration.cache_store
    Object.send(:remove_const, 'Rails')
  end
end