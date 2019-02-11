module CompanyRegister
  Company = Struct.new(:registration_number)

  class Client
    def initialize
      @cache = ActiveSupport::Cache.lookup_store(:file_store, 'tmp/cache')
    end

    # @citizen_country_code format [String] ISO 3166-1 alpha-3
    def representation_rights(citizen_personal_code:, citizen_country_code:)
      search_params = { 'fyysilise_isiku_kood' => citizen_personal_code,
                        'fyysilise_isiku_koodi_riik' => citizen_country_code,
                        'keel' => 'eng' }

      request = Request::RepresentationRights.new(search_params)
      response_body = @cache.fetch(request) do
        response = request.perform
        response.body
      end

      parse_representation_rights_response_body(response_body)
    end

    private

    def parse_representation_rights_response_body(body)
      return [] unless body[:esindus_v1_response][:keha][:ettevotjad]

      items = body[:esindus_v1_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map { |item| Company.new(item[:ariregistri_kood]) }
    end
  end
end