module CompanyRegister
  class Request
    def initialize(search_params)
      @soap_client = Savon.client(wsdl: CompanyRegister.configuration.wsdl,
                                  host: CompanyRegister.configuration.endpoint,
                                  endpoint: CompanyRegister.configuration.endpoint)
      @search_params = search_params
    end

    def perform
      soap_client.call(soap_operation, message: soap_message)
    end

    def cache_key
      'test'
    end

    private

    attr_reader :soap_client
    attr_reader :search_params

    def default_params
      { 'ariregister_kasutajanimi' => CompanyRegister.configuration.username,
        'ariregister_parool' => CompanyRegister.configuration.password }
    end

    def soap_message
      { keha: default_params.merge(search_params) }
    end
  end
end