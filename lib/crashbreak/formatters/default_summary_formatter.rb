module Crashbreak
  class DefaultSummaryFormatter < SummaryFormatter
    def summary
      { action: request.action }
    end

    private

    def request
      RequestStore.store[:request]
    end
  end
end
