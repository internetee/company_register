module CompanyRegister
  Company = Struct.new(:registration_number)

  class Client
    def initialize(soap_client)
      @soap_client = soap_client
    end

    # @citizen_country_code format [String] ISO 3166-1 alpha-3
    def representation_rights(citizen_personal_code:, citizen_country_code:)
      soap_operation = :esindus_v1

      params = { 'fyysilise_isiku_kood' => citizen_personal_code,
                 'fyysilise_isiku_koodi_riik' => citizen_country_code,
                 'keel' => 'eng' }

      response = send_request(soap_operation, params)
      parse_representation_rights_response(response)
    end

    private

    def send_request(soap_operation, params)
      @soap_client.call(soap_operation, message: { keha: params.merge(default_request_params) })
    end

    def default_request_params
      { 'ariregister_kasutajanimi' => CompanyRegister.configuration.username,
        'ariregister_parool' => CompanyRegister.configuration.password }
    end

    def parse_representation_rights_response(response)
      items = response.body[:esindus_v1_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map { |item| Company.new(item[:ariregistri_kood]) }
    end
  end
end