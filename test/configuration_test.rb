require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_configures_gem
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
      config.wsdl = 'http://wsdl.test'
      config.endpoint = 'http://company-register.test'
      config.cache_period = 1
    end

    assert_equal 'john', CompanyRegister.configuration.username
    assert_equal 'pwd', CompanyRegister.configuration.password
    assert_equal 'http://wsdl.test', CompanyRegister.configuration.wsdl
    assert_equal 'http://company-register.test', CompanyRegister.configuration.endpoint
    assert_equal 1, CompanyRegister.configuration.cache_period
  end
end