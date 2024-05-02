module CompanyRegister
  Company = Struct.new(:registration_number, :company_name, :status)

  CompanyDetails = Struct.new(
    :registration_number,
    :company_name,
    :status,
    :kandeliik,
  )

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
      response_body = cache_store.fetch(request, expires_in: CompanyRegister.configuration.cache_period) do
        response = request.perform
        filter_response_body(response.body, :esindus_v1_response)
      end

      parse_representation_rights_response_body(response_body)
    end

    def simple_data(registration_number:)
      search_params = { ariregistri_kood: registration_number, keel: 'eng' }

      request = Request::SimpleDataRequest.new(search_params)
      response = request.perform
      response_body = filter_response_body(response.body, :lihtandmed_v2_response)

      parse_simple_data_response_body(response_body)
    end

    # yandmed - If General Data is requested
    # iandmed - If Personnel Data is requested
    # kandmed - If Commercial Pledga data is requested
    # dandmed - If data of applications in proceeding is requested
    # maarused - If rulings are required
    def company_details(registration_number:, is_general_data: 1, is_personnel_data: 1, is_commercial_pledga: 0, is_data_proceed: 0, is_ruling: 0)
      search_params = { 
        ariregistri_kood: registration_number,
        yandmed: is_general_data, 
        iandmed: is_personnel_data, 
        kandmed: is_commercial_pledga, 
        dandmed: is_data_proceed, 
        maarused: is_ruling 
      }

      request = Request::CompanyDetailsRequest.new(search_params)
      response = request.perform
      response_body = filter_response_body(response.body, :detailandmed_v2_response)

      parse_company_details_response_body(response_body)
    end

    # liik: K – request for entries; M – request for rulings.
    # algus_kpv: The input already takes into account summer and winter time. The maximum search period is one day. The date must not be less than 01.01.2013
    # lopp_kpv: The input already takes into account summer and winter time. The maximum search period is one day. The date must not be less than the start date.
    def entries_and_rulings(request_type: 'M', start_at: '2019-01-18T11:57:00', ends_at: '2019-01-19T11:57:00', lang: 'eng')
      search_params = { 
        keel: lang,
        liik: request_type,
        algus_kpv: start_at,
        lopp_kpv: ends_at
      }

      request = Request::EntriesAndRulingsRequest.new(search_params)
      response = request.perform
      response_body = filter_response_body(response.body, :kanded_maarused_v1_response)

      parse_entries_and_rulings_response_body(response_body)
    end

    private

    attr_reader :cache_store

    def filter_response_body(body, response_type)
      # Avoid parameter mutation
      body = Marshal.load(Marshal.dump(body))

      body[response_type][:paring].delete_if do |key, _value|
        RESPONSE_FILTERED_PARAMS.include?(key)
      end

      body
    end

    def parse_representation_rights_response_body(body)
      return [] unless body[:esindus_v1_response][:keha][:ettevotjad]

      items = body[:esindus_v1_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map do |item|
        Company.new(item[:ariregistri_kood], item[:arinimi])
      end
    end

    def parse_simple_data_response_body(body)
      return [] unless body[:lihtandmed_v2_response][:keha][:ettevotjad]

      items = body[:lihtandmed_v2_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map do |item|
        Company.new(item[:ariregistri_kood], item[:evnimi], item[:staatus])
      end
    end

    def parse_company_details_response_body(body)
      return [] unless body[:detailandmed_v2_response][:keha][:ettevotjad]

      items = body[:detailandmed_v2_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map do |item|
        kandeliik = item[:registrikaardid][:item][:kanded].map do |reg_pair|
          reg_pair[1].map do |reg|
            Struct.new(:kandeliik, :kandeliik_tekstina)
              .new(reg[:kandeliik], reg[:kandeliik_tekstina])
          end
        end
      
        CompanyDetails.new(
          item[:ariregistri_kood], item[:nimi], item[:yldandmed][:staatus], kandeliik.flatten
        )
      end
    end

    def parse_entries_and_rulings_response_body(body)
      return [] unless body[:kanded_maarused_v1_response][:keha][:ettevotjad]

      items = body[:kanded_maarused_v1_response][:keha][:ettevotjad][:item]
      items = [items] unless items.kind_of?(Array)
      items.map do |item|
        maarused = unless item[:maarused][:item][0].nil?
          Struct.new(:kandeliik, :kandeliik_tekstina, :maaruse_liik, :maaruse_liik_tekstina)
                .new(
                  item[:maarused][:item][0][:kandeliik],
                  item[:maarused][:item][0][:kandeliik_tekstina],
                  item[:maarused][:item][0][:maaruse_liik],
                  item[:maarused][:item][0][:maaruse_liik_tekstina]
                )
        else
          []
        end
      
        CompanyDetails.new(
          item[:ariregistri_kood], item[:evnimi], item[:staatus], maarused
        )
      end
    end
  end
end
