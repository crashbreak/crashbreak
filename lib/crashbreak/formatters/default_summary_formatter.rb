module Crashbreak
  class DefaultSummaryFormatter < SummaryFormatter
    def summary(exception)
      { action: 'example_action_name' }
    end
  end
end
