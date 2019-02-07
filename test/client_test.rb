require 'test_helper'

class CompanyRegisterTest < Minitest::Test
  def test_queries_representation_rights
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
      config.wsdl = 'http://company-register.test/wsdl'
      config.endpoint = 'http://company-register.test'
    end

    wsdl_response_body = File.read('test/fixtures/wsdl.xml')
    stub_request(:get, 'http://company-register.test/wsdl').to_return(status: 200,
                                                                      body: wsdl_response_body)

    request_stub = stub_request(:post, "http://company-register.test/").
        with(
            body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ar=\"http://arireg.x-road.eu/producer/\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\"><env:Body><ar:esindus_v1><ar:keha><ar:fyysilise_isiku_kood>1234</ar:fyysilise_isiku_kood><ar:fyysilise_isiku_koodi_riik>USA</ar:fyysilise_isiku_koodi_riik><ar:keel>eng</ar:keel><ar:ariregister_kasutajanimi>john</ar:ariregister_kasutajanimi><ar:ariregister_parool>pwd</ar:ariregister_parool></ar:keha></ar:esindus_v1></env:Body></env:Envelope>",
            headers: { 'Soapaction' => '"esindus_v1"' })
                       .to_return(status: 200, body: File.read('test/fixtures/representation_rights_response.xml'))

    client = CompanyRegister::Client.new
    companies = client.representation_rights(citizen_personal_code: '1234',
                                             citizen_country_code: 'USA')

    assert_requested request_stub
    assert_kind_of Array, companies
    assert_kind_of CompanyRegister::Company, companies.first
    assert_equal '12345', companies.first.registration_number
  end
end