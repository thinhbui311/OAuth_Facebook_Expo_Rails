Given("I am on the home page") do
  visit "/"
end

Then("I should see login button") do
  expect(page.body).to have_content "Facebook login"
end

When("I click loggin button") do
  find('div[data-testID="loginButton"]').click
end

When("I click login button then Facebook authorize window show up and close window") do
  facebook_window = window_opened_by do
    find('div[data-testID="loginButton"]').click
  end
  within_window facebook_window do
    page.current_window.close
  end
end

When("I click login button then Facebook authorize window show up and authorize") do
end

Then("I can see my facebook info") do
end

And("I click logout button") do
  # find('div[data-testID="logoutButton"]').click
end
