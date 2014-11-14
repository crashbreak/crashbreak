module Crashbreak
  class DefaultSummaryFormatter < SummaryFormatter
    def summary
      { action: 'example_action_name' }
    end
  end
end
