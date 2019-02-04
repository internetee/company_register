module CompanyRegister
  class Client
    def initialize(soap_client)
      @soap_client = soap_client
    end

    def companies(citizen_personal_code: nil)
      @soap_client.call(:esindus_v1, message: { keha: { 'ariregister_kasutajanimi' => CompanyRegister.configuration.username,
                                                        'ariregister_parool' => CompanyRegister.configuration.password,
                                                        'fyysilise_isiku_kood' => citizen_personal_code,
                                                        'fyysilise_isiku_koodi_riik' => 'EST',
                                                        'keel' => 'eng', } })
    end
  end
end