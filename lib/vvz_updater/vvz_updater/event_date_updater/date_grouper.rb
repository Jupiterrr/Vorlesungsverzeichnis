module VVZUpdater
  class EventDateUpdater
    class DateGrouper

      def initialize(dates, db_dates)
        @date_set = ValueSet.new(dates, :id)
        @db_date_set = ValueSet.new(db_dates, :uuid)
      end

      def new_dates
        new_ids = @date_set - @db_date_set
        new_ids.map {|id| @date_set[id] }
      end

      def removed_db_dates
        removed_ids = @db_date_set - @date_set
        removed_ids.map {|id| @db_date_set[id] }
      end

      def existing_date_pairs
        existing_ids = @date_set & @db_date_set
        existing_ids.map {|id| DatePair.new(@date_set[id], @db_date_set[id]) }
      end

      DatePair = Struct.new(:date, :db_date)

    end
  end
end

