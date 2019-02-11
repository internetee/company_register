module CompanyRegister
  class Configuration
    attr_accessor :username
    attr_accessor :password
    attr_accessor :wsdl
    attr_accessor :endpoint

    # See https://github.com/rails/rails/tree/master/activesupport/lib/active_support/cache for the
    # list of available stores. Ensure the store chosen is supported by activesupport version you
    # are using. Set to Rails.cache when used with Rails.
    attr_accessor :cache_store

    attr_accessor :cache_period

    def initialize
      self.cache_store = ActiveSupport::Cache::MemoryStore.new
    end
  end
end