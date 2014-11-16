module Crashbreak
  class DefaultSummaryFormatter < SummaryFormatter
    def summary
      { action: request.action, controller_name: controller.class.to_s }
    end
  end
end
