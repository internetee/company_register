require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_configures_params
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
      config.wsdl = 'http://wsdl.test'
      config.endpoint = 'http://company-register.test'
    end

    assert_equal 'john', CompanyRegister.configuration.username
    assert_equal 'pwd', CompanyRegister.configuration.password
    assert_equal 'http://wsdl.test', CompanyRegister.configuration.wsdl
    assert_equal 'http://company-register.test', CompanyRegister.configuration.endpoint
  end
end