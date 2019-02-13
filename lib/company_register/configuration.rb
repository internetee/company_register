module CompanyRegister
  class Configuration
    attr_accessor :username
    attr_accessor :password

    # See https://github.com/rails/rails/tree/master/activesupport/lib/active_support/cache for the
    # list of available stores. Ensure the store chosen is supported by activesupport version you
    # are using. Rails.cache is the default when used with Rails.
    attr_accessor :cache_store

    attr_accessor :cache_period

    def initialize
      self.cache_store = Rails.cache if defined?(Rails)
    end
  end
end