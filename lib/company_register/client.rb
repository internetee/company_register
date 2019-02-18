module CompanyRegister
  Company = Struct.new(:registration_number)

  class Client
    # API returns request params back with the response. They are stripped out to avoid caching
    # them.
    RESPONSE_FILTERED_PARAMS = %i[ariregister_kasutajanimi ariregister_parool]
    private_constant :RESPONSE_FILTERED_PARAMS

    def initialize(cache_store = CompanyRegister.configuration.cache_store)
      @cache_store = cache_store
    end

    # @citizen_country_code format [String] ISO 3166-1 alpha-3
    def representation_rights(citizen_personal_code:, citizen_country_code:)
      search_params = { fyysilise_isiku_kood: citizen_personal_code,
                        fyysilise_isiku_koodi_riik: citizen_country_code,
                        keel: 'eng' }

      request = Request::RepresentationRightsRequest.new(search_params)
      response_body = cache_store.fetch(request,
                                        expires_in: CompanyRegister.configuration.cache_period) do
        response = request.perform
        filter_response_body(response.body)
      end

      parse_representation_rights_response_body(response_body)
    end

    private

    attr_reader :cache_store

    def filter_response_body(body)
      # Avoid parameter mutation
      body = Marshal.load(Marshal.dump(body))

      body[:esindus_v1_response][:paring].delete_if do |key, _value|
        RESPONSE_FILTERED_PARAMS.include?(key)
      end

      body
    end

    def parse_representation_rights_response_body(body)
      return [] unless body[:esindus_v1_response][:keha][:ettevotjad]

      items = body[:esindus_v1_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map { |item| Company.new(item[:ariregistri_kood]) }
    end
  end
end