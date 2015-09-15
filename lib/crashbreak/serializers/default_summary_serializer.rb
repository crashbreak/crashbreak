module Crashbreak
  class DefaultSummarySerializer < SummarySerializer
    def summary
      {
          action: request.env['PATH_INFO'],
          controller_name: controller.class.to_s,
          file: exception.backtrace[0],
          url: request.env['REQUEST_URI'],
          user_agent: request.env['HTTP_USER_AGENT']
      }
    end
  end
end
