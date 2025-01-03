module CompanyRegister
  class Request
    class EntriesAndRulingsRequest < Request
      private

      def soap_operation
        :kanded_maarused_v1
      end
    end
  end
end