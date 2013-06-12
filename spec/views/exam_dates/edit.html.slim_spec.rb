# require 'spec_helper'

# describe "exam_dates/edit" do
#   before(:each) do
#     @exam_date = assign(:exam_date, stub_model(ExamDate,
#       :event => nil,
#       :discipline => nil,
#       :data => "",
#       :type => "",
#       :name => "MyString"
#     ))
#   end

#   it "renders the edit exam_date form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => exam_dates_path(@exam_date), :method => "post" do
#       assert_select "input#exam_date_event", :name => "exam_date[event]"
#       assert_select "input#exam_date_discipline", :name => "exam_date[discipline]"
#       assert_select "input#exam_date_data", :name => "exam_date[data]"
#       assert_select "input#exam_date_type", :name => "exam_date[type]"
#       assert_select "input#exam_date_name", :name => "exam_date[name]"
#     end
#   end
# end
