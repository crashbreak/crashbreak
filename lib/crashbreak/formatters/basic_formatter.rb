module Crashbreak
  class BasicFormatter

    protected

    def exception
      RequestStore.store[:exception]
    end

    def request
      RequestStore.store[:request]
    end
  end
end
