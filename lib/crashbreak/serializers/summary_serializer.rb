module Crashbreak
  class SummarySerializer < BasicSerializer
    def serialize
      { summary: summary }
    end

    def summary
      {}
    end
  end
end
