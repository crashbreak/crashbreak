module Crashbreak
  class TestErrorSerializer < Crashbreak::HashSerializer
    hash_name :test

    def hash_value
      { example_key: true }
    end
  end
end