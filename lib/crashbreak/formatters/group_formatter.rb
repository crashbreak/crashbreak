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

    def format(exception)
      { additional_data: { self.class.get_group_name => group_hash(exception) } }
    end
  end
end
