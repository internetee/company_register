module CompanyRegister
  class Configuration
    attr_accessor :username
    attr_accessor :password

    # See https://github.com/rails/rails/tree/master/activesupport/lib/active_support/cache for the
    # list of available stores. Ensure the store chosen is supported by activesupport version you
    # are using. Rails.cache is the default when used with Rails.
    attr_accessor :cache_store

    attr_reader :cache_period

    # Requests in test mode are free of charge
    attr_accessor :test_mode

    def initialize
      self.cache_store = Rails.cache if defined?(Rails)
    end

    def cache_period=(value)
      unless value.kind_of?(ActiveSupport::Duration)
        raise ArgumentError, 'Instance of ActiveSupport::Duration is expected'
      end

      @cache_period = value
    end
  end
end