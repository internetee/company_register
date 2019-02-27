require 'test_helper'

class ConcreteRequest < CompanyRegister::Request; end

class RequestTest < Minitest::Test
  def test_cache_key
    CompanyRegister.configure {}
    request = ConcreteRequest.new(name: 'john')
    assert_equal ({ name: 'john' }).to_json, request.cache_key
  end
end