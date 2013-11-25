require "set"
module VVZUpdater
  class EventDateUpdater
    class ValueSet < Set

      def initialize(ary, key_retriver)
        @index = ValueSet.index_by(ary, &key_retriver)
        super(@index.keys)
      end

      # index_by([1,2], &:to_s) => {"1" => 1, "2" => 2}
      def self.index_by(ary, &block)
        Hash[*ary.flat_map {|item| [block.call(item), item]}]
      end

      def [](key)
        @index[key]
      end

      def &(other_set)
        # & trys to copy and fails
        # so delegate to normal set
        to_set & other_set
      end

    end
  end
end
