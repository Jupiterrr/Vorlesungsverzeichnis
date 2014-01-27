When(/^I write a comment and submit it$/) do
  @text = "comment"
  post_el = find(".post")
  form = post_el.find(".comment-form")
  form.fill_in "comment", with: @text
  form.find("textarea").native.send_keys(:Enter)
  sleep 0.1
  #wait_for_ajax
end

Then(/^I see the comment$/) do
  find(".comment p").should have_content(@text)
end

Given(/^a comment I wrote$/) do
  @comment = @post.comment(@current_user, "test")
  visit(current_path)
end

When(/^I delete the comment$/) do
  find(".comment").hover
  find(".js-comment-delete-btn").click
  sleep 0.1
end

Then(/^the comment should dissapear$/) do
  expect( Comment.exists?(@comment) ).to be_false
end

# page.driver.debug
