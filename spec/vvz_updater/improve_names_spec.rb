# encoding: UTF-8
require "spec_helper"
require "vvz_updater/vvz_updater/data_enhancement"

describe VVZUpdater::DataEnhancer do

  let(:term) { "term" }
  subject { VVZUpdater::DataEnhancer.new(term, logging: false) }

  describe "main event doesn't exist" do
    it "doesn't improve incorrect names" do
      event = Event.create(name: "Übung 123", term: term)
      subject.improve_name(event)
      event.name.should == "Übung 123"
    end
  end

  describe "main event exists" do
    before(:each) { Event.create(name: "Wurst-Vorlesung I", no: 123, term: term) }
    it "doesn't improve correct names" do
      event = Event.create(name: "Übung zu Wurst-Vorlesung I", term: term)
      subject.improve_name(event)
      event.name.should == "Übung zu Wurst-Vorlesung I"
    end
    it "improve bad name" do
      event = Event.create(name: "Übung zu 123", term: term)
      subject.improve_name(event)
      event.name.should == "Übung zu Wurst-Vorlesung I"
    end
  end

  it "only uses events within the same term" do
    master = Event.create(name: "Wurst-Vorlesung I", no: 123, term: "not term")
    event = Event.create(name: "Übung zu 123", term: term)
    subject.improve_name(event)
    event.name.should_not == "Übung zu Wurst-Vorlesung I"
  end

  describe VVZUpdater::DataEnhancer::GenericMatcher do
    it "fixes" do
      matcher = VVZUpdater::DataEnhancer::GenericMatcher.new("Tutorium zu 123")
      matcher.fix_name("Master").should == "Tutorium zu Master"
    end
    it "detects" do
      matcher = VVZUpdater::DataEnhancer::GenericMatcher.new("Tutorium zu 123")
      matcher.match?.should be_true
    end
    it "returns event number" do
      matcher = VVZUpdater::DataEnhancer::GenericMatcher.new("Tutorium zu 123")
      matcher.event_no.should == "123"
    end
    it "fixes Tutorial" do
      matcher = VVZUpdater::DataEnhancer::GenericMatcher.new("Tutorial for  0113100")
      matcher.fix_name("X").should == "Tutorium zu X"
    end
    it "fixes Übung" do
      matcher = VVZUpdater::DataEnhancer::GenericMatcher.new("Übung zu 123")
      matcher.fix_name("X").should == "Übung zu X"
    end
    it "fixes Ergänzungen" do
      matcher = VVZUpdater::DataEnhancer::GenericMatcher.new("Ergänzungen zu 123")
      matcher.fix_name("X").should == "Ergänzungen zu X"
    end
  end

end
