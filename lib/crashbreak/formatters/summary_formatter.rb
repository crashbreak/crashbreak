module Crashbreak
  class SummaryFormatter
    def format(exception)
      { summary: { action: 'example_action_name' }}
    end
  end
end
