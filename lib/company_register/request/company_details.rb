module CompanyRegister
  class Request
    class CompanyDetailsRequest < Request
      private

      def soap_operation
        :detailandmed_v2
      end
    end
  end
end