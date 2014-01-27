When(/^I am allowed to use post feature$/) do
  @current_user.data["post_feature_flip"] = "true"
  @current_user.save!
end

When(/^I write a post$/) do
  @text = "test post"
  with_scope(".post-form") do
    fill_in("text", :with => @text)
  end
end

When(/^submit it$/) do
  with_scope(".post-form") do
    find(".js-submit-btn").click
  end
end

Then(/^I should see it$/) do
  find(".posts").should have_content(@text)
end

Given(/^a post I have written$/) do
  board = @event.board.typed_board
  @post = board.post(@current_user, "test post")
  visit(current_path)
end

When(/^I delete the post$/) do
  post_el = find(".post")
  post_el.find(".js-post-delete-btn").click
  sleep 0.5
end

Then(/^the post should dissapear$/) do
  expect( Post.exists?(@post) ).to be_false
end

Given(/^a post for the event$/) do
  step "a post I have written"
end

# page.driver.debug
