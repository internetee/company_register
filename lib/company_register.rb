require 'savon'

require 'company_register/version'
require 'company_register/client'
require 'company_register/configuration'

module CompanyRegister
  class Error < StandardError;
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end