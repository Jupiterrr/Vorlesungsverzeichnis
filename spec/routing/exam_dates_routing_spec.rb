require "spec_helper"

describe ExamDatesController do
  describe "routing" do

    it "routes to #index" do
      get("/exam_dates").should route_to("exam_dates#index")
    end

    it "routes to #new" do
      get("/exam_dates/new").should route_to("exam_dates#new")
    end

    it "routes to #show" do
      get("/exam_dates/1").should route_to("exam_dates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/exam_dates/1/edit").should route_to("exam_dates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/exam_dates").should route_to("exam_dates#create")
    end

    it "routes to #update" do
      put("/exam_dates/1").should route_to("exam_dates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/exam_dates/1").should route_to("exam_dates#destroy", :id => "1")
    end

  end
end
