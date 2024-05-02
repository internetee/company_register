module CompanyRegister
  class Request
    class SimpleDataRequest < Request
      private

      def soap_operation
        :lihtandmed_v2
      end
    end
  end
end