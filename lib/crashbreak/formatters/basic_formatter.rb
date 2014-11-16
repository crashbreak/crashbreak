module Crashbreak
  class BasicFormatter

    protected

    def exception
      RequestStore.store[:exception]
    end

    def request
      RequestStore.store[:request]
    end

    def controller
      RequestStore.store[:controller]
    end
  end
end
