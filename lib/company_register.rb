require 'savon'
require 'active_support'

require 'company_register/version'
require 'company_register/client'
require 'company_register/configuration'
require 'company_register/request'
require 'company_register/request/representation_rights'
require 'company_register/request/company_details'

module CompanyRegister
  class Error < StandardError; end
  class NotAvailableError < Error; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end