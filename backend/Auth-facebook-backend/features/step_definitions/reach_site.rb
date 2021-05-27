Given("I am on the home page") do
  visit "/"
end

Then("I should see login button") do
  expect(page.body).to have_content "Facebook login"
end

When("I click loggin button") do
  find("div", role: "button", exact: true).click
end

Then("Facebook authorize window show up") do
end

But("I turn off authorize window") do
end

And("I click to accept authorize") do
end

Then("I can see my facebook info") do
end

And("I click logout button") do
end

Then("I get back to home page") do
end
