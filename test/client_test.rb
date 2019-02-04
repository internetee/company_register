require 'test_helper'

class CompanyRegisterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CompanyRegister::VERSION
  end

  def test_returns_company_list_by_citizen_personal_code
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
    end

    soap_client = Minitest::Mock.new
    soap_client.expect(:call, true, [:esindus_v1, { message: { keha: { 'ariregister_kasutajanimi' => 'john',
                                                                       'ariregister_parool' => 'pwd',
                                                                       'fyysilise_isiku_kood' => '1234',
                                                                       'fyysilise_isiku_koodi_riik' => 'EST',
                                                                       'keel' => 'eng' } } }])
    client = CompanyRegister::Client.new(soap_client)

    companies = client.companies(citizen_personal_code: '1234')

    soap_client.verify
    assert_kind_of Array, companies
    assert_kind_of CompanyRegister::Company, companies.first
    assert_kind_of 'some', companies.first.code
  end
end