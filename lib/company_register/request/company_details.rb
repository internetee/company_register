module CompanyRegister
  class Request
    class CompanyDetailsRequest < Request
      private

      def soap_operation
        :lihtandmed_v2
      end
    end
  end
end