require "spec_helper"
require "vvz_updater/vvz_updater"


describe VVZUpdater, vcr: {match_requests_on: [:body, :uri], record: :new_episodes} do

  # describe ".update_event", no_ci: true do
  #   it "updates correctly" do
  #     db_event = Event.create! external_id: "0xaefda07be09a7c43875d5ce13378a1cc"
  #     updater = VVZUpdater.update_event(db_event, false)
  #     db_event.dates.should have(23).items
  #     db_event.dates.map(&:room_id).flatten.should have(23).items
  #   end
  # end

  describe ".update" do

    describe ".update_tree" do
      it "migrates tree" do
        VVZUpdater.update_tree("SS 2010")
        expect(Vvz.count).to eql(605)
        expect(Vvz.leafs.count).to eql(369)
      end
    end

    describe ".update_events" do
      it "migrates tree" do
        VVZUpdater.update_events("SS 2010")
        expect(Event.count).to eql(4281)
        expect(EventDate.count).to eql(40425)
        expect(Room.count).to eql(280)
      end
    end

    it "updates" do
      VVZUpdater.update("SS 2010")
      leaf = Vvz.term("KIT", "SS 2010").leafs.first
      expect(leaf.events.count).to have(8).item
    end

    # it ".mirgrate_tree!" do
    #   VVZUpdater.mirgrate_tree!(tree, "SS 2006")
    #   expect(Vvz.count).to eql(358)
    #   expect(Vvz.leafs.count).to eql(278)
    # end

    # it ".link_events!" do
    #   VVZUpdater.mirgrate_tree!(tree, "SS 2006")
    #   VVZUpdater.link_events!(tree, "SS 2006")
    #   expect(Event.count).to eql(2639)
    #   leaf = Vvz.find_by_external_id("0x7a0be8bc8a34db4288909b42365f925e")
    #   expect(leaf.event_ids.count).to eql(57)
    # end

    # let(:db_event) { Event.create({external_id: "0x000be91dfd3c7343a9500d79936ffb7e"}) }
    # it "update_event!" do
    #   VVZUpdater.update_event!(package_dir, db_event)
    #   expect(db_event.dates.count).to eql(29)
    #   expect(db_event.name).to eql("Allgemeine Biologie IV (Modul 10)")
    # end

  end

end
