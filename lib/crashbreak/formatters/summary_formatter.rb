module Crashbreak
  class SummaryFormatter
    def format(exception)
      { summary: summary(exception) }
    end

    def summary(exception)
      {}
    end
  end
end
