require 'test_helper'
require 'ostruct'

class ConfigurationTest < Minitest::Test
  def test_configures_gem
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
      config.wsdl = 'http://wsdl.test'
      config.endpoint = 'http://company-register.test'
      config.cache_store = 'some store'
      config.cache_period = 1
    end

    assert_equal 'john', CompanyRegister.configuration.username
    assert_equal 'pwd', CompanyRegister.configuration.password
    assert_equal 'http://wsdl.test', CompanyRegister.configuration.wsdl
    assert_equal 'http://company-register.test', CompanyRegister.configuration.endpoint
    assert_equal 'some store', CompanyRegister.configuration.cache_store
    assert_equal 1, CompanyRegister.configuration.cache_period

    CompanyRegister.configuration = nil
  end

  def test_sets_default_cache_store_when_used_with_rails
    Object.const_set('Rails', OpenStruct.new(cache: 'rails-cache-store'))
    CompanyRegister.configure {}
    assert_equal 'rails-cache-store', CompanyRegister.configuration.cache_store
    Object.send(:remove_const, 'Rails')
  end
end