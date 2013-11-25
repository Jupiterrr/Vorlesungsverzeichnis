require "vcr_helper"
require "vvz_updater/vvz_updater"

class VVZUpdater::EventDateUpdater
  describe DateGrouper do
    let(:dates) {
      [stub("Date", id: 1), stub("Date", id: 2)]
    }
    let(:db_dates) {
      [stub("DBDate", uuid: 1), stub("DBDate", uuid: 2)]
    }

    describe "new_dates" do
      subject { DateGrouper.new(dates, []) }
      it "finds new dates" do
        expect(subject.new_dates).to eql dates
      end
    end

    describe "removed_db_dates" do
      subject { DateGrouper.new([], db_dates) }
      it "finds removed db_dates" do
        expect(subject.removed_db_dates).to eql db_dates
      end
    end

    describe "existing_date_pairs" do
      subject { DateGrouper.new(dates, db_dates) }
      it "finds pairs" do
        pairs = [
          DateGrouper::DatePair.new(dates[0], db_dates[0]),
          DateGrouper::DatePair.new(dates[1], db_dates[1])
        ]
        expect(subject.existing_date_pairs).to eql pairs
      end
    end

  end
end
