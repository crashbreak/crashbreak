module Crashbreak
  class GroupFormatter
    class << self
      def group_name(value)
        @group_name = value
      end

      def get_group_name
        @group_name
      end
    end

    def serialize
      { additional_data: { self.class.get_group_name => group_hash } }
    end
  end
end
