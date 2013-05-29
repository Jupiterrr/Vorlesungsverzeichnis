# encoding: UTF-8
require "spec_helper"
require 'data_enhancement'

describe "data_enhancement" do

  describe "main event doesn't exist" do
    it "doesn't improve incorrect names" do
      event = Event.create(name: "Übung 123")
      DataEnhancement.improve_name(event)
      event.name.should == "Übung 123"
    end
  end

  describe "main event exists" do
    before(:each) { Event.create(name: "Wurst-Vorlesung I", nr: 123) }
    it "doesn't improve correct names" do
      event = Event.create(name: "Übung zu Wurst-Vorlesung I")
      DataEnhancement.improve_name(event)
      event.name.should == "Übung zu Wurst-Vorlesung I"
    end
    it "improve bad name" do
      event = Event.create(name: "Übung 123")
      DataEnhancement.improve_name(event)
      event.name.should == "Übung zu Wurst-Vorlesung I"
    end
  end

end
