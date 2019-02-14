require 'test_helper'

class CompanyRegisterTest < Minitest::Test
  def setup
    CompanyRegister.configure do |config|
      config.username = 'john'
      config.password = 'pwd'
      config.cache_store = ActiveSupport::Cache::NullStore.new
    end
    stub_wsdl_request
  end

  def teardown
    CompanyRegister.configuration = nil
    WebMock.reset!
  end

  def test_makes_a_request_when_cache_is_empty
    request = stub_request_without_payload

    client = CompanyRegister::Client.new
    client.representation_rights(citizen_personal_code: '1234', citizen_country_code: 'USA')

    assert_requested request
  end

  def test_caches_response
    stub_request_without_payload

    cache_store = ActiveSupport::Cache::MemoryStore.new

    client = CompanyRegister::Client.new(cache_store)
    client.representation_rights(citizen_personal_code: '1234',
                                 citizen_country_code: 'USA')


    cache_key = { 'fyysilise_isiku_kood' => '1234',
                  'fyysilise_isiku_koodi_riik' => 'USA',
                  'keel' => 'eng' }.to_json
    expected_cache_value = { esindus_v1_response: { paring: { fyysilise_isiku_kood: '1234',
                                                              fyysilise_isiku_koodi_riik: 'USA',
                                                              keel: 'eng' },
                                                    keha: { ettevotjad: nil } },
                             :"@xmlns:ns1" => 'http://arireg.x-road.eu/producer/' }
    assert_equal expected_cache_value, cache_store.read(cache_key)
  end

  def test_does_not_make_a_request_when_response_is_cached
    cache_key = { fyysilise_isiku_kood: '1234',
                  fyysilise_isiku_koodi_riik: 'USA',
                  keel: 'eng' }.to_json
    cache_value = { esindus_v1_response: { paring: { fyysilise_isiku_kood: '1234',
                                                     fyysilise_isiku_koodi_riik: 'USA',
                                                     keel: 'eng' },
                                           keha: { ettevotjad: nil } },
                    :"@xmlns:ns1" => 'http://arireg.x-road.eu/producer/' }

    cache_store = ActiveSupport::Cache::MemoryStore.new
    cache_store.write(cache_key, cache_value)

    client = CompanyRegister::Client.new(cache_store)
    client.representation_rights(citizen_personal_code: '1234', citizen_country_code: 'USA')
  end

  def test_parses_response_with_payload
    stub_request_with_payload

    client = CompanyRegister::Client.new
    companies = client.representation_rights(citizen_personal_code: '1234',
                                             citizen_country_code: 'USA')

    assert_kind_of Array, companies
    assert_kind_of CompanyRegister::Company, companies.first
    assert_equal '12345', companies.first.registration_number
  end

  def test_parses_response_without_payload
    stub_request_without_payload

    client = CompanyRegister::Client.new
    companies = client.representation_rights(citizen_personal_code: '1234',
                                             citizen_country_code: 'USA')

    assert_empty companies
  end

  private

  def stub_wsdl_request
    response_body = File.read('test/fixtures/wsdl.xml')
    stub_request(:get, 'http://company-register.test/wsdl').to_return(status: 200,
                                                                      body: response_body)
  end

  def stub_request_with_payload
    response_body = File.read('test/fixtures/representation_rights_response_with_payload.xml')
    stub_request(:post, 'http://company-register.test').
        with(
            body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ar=\"http://arireg.x-road.eu/producer/\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\"><env:Body><ar:esindus_v1><ar:keha><ar:ariregister_kasutajanimi>john</ar:ariregister_kasutajanimi><ar:ariregister_parool>pwd</ar:ariregister_parool><ar:fyysilise_isiku_kood>1234</ar:fyysilise_isiku_kood><ar:fyysilise_isiku_koodi_riik>USA</ar:fyysilise_isiku_koodi_riik><ar:keel>eng</ar:keel></ar:keha></ar:esindus_v1></env:Body></env:Envelope>",
            headers: { 'Soapaction' => '"esindus_v1"' }).to_return(status: 200, body: response_body)
  end

  def stub_request_without_payload
    response_body = File.read('test/fixtures/representation_rights_response_without_payload.xml')
    stub_request(:post, 'http://company-register.test').to_return(status: 200,
                                                                  body: response_body)
  end
end