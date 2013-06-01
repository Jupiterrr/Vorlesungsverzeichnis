require 'spec_helper'

describe "exam_dates/index" do
  before(:each) do
    assign(:exam_dates, [
      stub_model(ExamDate,
        :event => nil,
        :discipline => nil,
        :data => "",
        :type => "Type",
        :name => "Name"
      ),
      stub_model(ExamDate,
        :event => nil,
        :discipline => nil,
        :data => "",
        :type => "Type",
        :name => "Name"
      )
    ])
  end

  it "renders a list of exam_dates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
