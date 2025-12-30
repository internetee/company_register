module CompanyRegister
  class Request
    class EInvoiceRecipientsRequest < Request
      private

      def soap_operation
        :earve_registri_paring_v1
      end
    end
  end
end
