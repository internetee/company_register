module CompanyRegister
  class Request
    WSDL_TEST = 'https://demo-ariregxmlv6.rik.ee/?wsdl'
    private_constant :WSDL_TEST

    WSDL_PRODUCTION = 'https://ariregxmlv6.rik.ee/?wsdl'
    private_constant :WSDL_PRODUCTION

    ENDPOINT_TEST = 'https://demo-ariregxmlv6.rik.ee/'
    private_constant :ENDPOINT_TEST

    ENDPOINT_PRODUCTION = 'https://ariregxmlv6.rik.ee/'
    private_constant :ENDPOINT_PRODUCTION

    def initialize(search_params)
      @soap_client = Savon.client(wsdl: WSDL_TEST,
                                  host: ENDPOINT_TEST,
                                  endpoint: ENDPOINT_TEST,
                                  filters: %w[ariregister_kasutajanimi ariregister_parool],
                                  convert_request_keys_to: :none)
      @search_params = search_params
    end

    def perform
      soap_client.call(soap_operation, message: soap_message)
    end

    def cache_key
      search_params.to_json
    end

    private

    attr_reader :soap_client
    attr_reader :search_params

    def default_params
      { ariregister_kasutajanimi: CompanyRegister.configuration.username,
        ariregister_parool: CompanyRegister.configuration.password }
    end

    def soap_message
      { keha: default_params.merge(search_params) }
    end
  end
end