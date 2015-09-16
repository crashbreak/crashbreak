module Crashbreak
  class SessionRestorer
    def initialize(session_data)
      @session_data = session_data
    end

    def restore
      @session_data.tap do |session_data|
        $session_data = session_data # pass it via global variable to restorers middleware
      end
    end
  end
end