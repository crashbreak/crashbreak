module Crashbreak
  module Configurable
    def configure
      yield configurator if block_given?
      configurator
    end

    def configurator
      @@configurator ||= Configurator.new
    end
  end
end
