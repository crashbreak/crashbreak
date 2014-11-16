module Crashbreak
  class SummaryFormatter < BasicFormatter
    def serialize
      { summary: summary }
    end

    def summary
      {}
    end
  end
end
