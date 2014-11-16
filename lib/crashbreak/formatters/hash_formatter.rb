module Crashbreak
  class HashFormatter < BasicFormatter
    class << self
      def hash_name(value)
        @hash_name = value
      end

      def get_hash_name
        @hash_name
      end
    end

    def serialize
      { additional_data: { self.class.get_hash_name => hash_value } }
    end
  end
end
