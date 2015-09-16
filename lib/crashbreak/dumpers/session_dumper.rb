module Crashbreak
  class SessionDumper < Crashbreak::BasicSerializer
    def dump
      request.session.to_hash
    end
  end
end