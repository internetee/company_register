module CompanyRegister
  class Request
    class RepresentationRights < Request
      private

      def soap_operation
        :esindus_v1
      end
    end
  end
end