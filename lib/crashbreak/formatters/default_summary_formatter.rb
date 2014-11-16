module Crashbreak
  class DefaultSummaryFormatter < SummaryFormatter
    def summary
      { action: request.action }
    end
  end
end
