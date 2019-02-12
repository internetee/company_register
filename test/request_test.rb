require 'test_helper'

class RequestTest < Minitest::Test
  def test_caches_by_search_params
    request = CompanyRegister::Request.new(name: 'john')
    assert_equal '{\"name\":\"john\"}', request.cache_key
  end
end