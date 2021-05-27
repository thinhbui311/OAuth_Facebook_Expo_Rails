require "cucumber/rspec/doubles"

Given("I am on the home page") do
  visit "/"
end

Then("I should see login button") do
  expect(page.body).to have_content "Facebook login"
end

When("I click login button") do
  find('div[data-testID="loginButton"]').click
end

Then("I see facebook authorize window show up") do
  expect(windows.count).to eq 2
end

But("I close facebook authorize window") do
  within_window(windows.last) do
    page.current_window.close
  end
end

And("I fill in my credentials but it is wrong") do
  within_window(windows.last) do
    fill_in("email", with: "User_1@gmail.com")
    fill_in("pass", with: "1234")
    click_button("login")
  end
end

And("I fill in my correct credentials") do
  RSpec::Mocks.with_temporary_scope do
    basic_user_info = { name: "User_1", id: 1234 }
    access_token = "random_access_token"

    allow(OauthProvider::Facebook).to receive(:authenticate).and_return([basic_user_info, access_token])

    within_window(windows.last) do
      fill_in("email", with: "test_rluyuzn_user@tfbnw.net")
      fill_in("pass", with: "abcd1234*")
      click_button("login")
      sleep 3
    end
  end
end

Then("I can see my facebook info") do
  within_window(windows.first) do
    sleep 3
    expect(page.body).to have_content "Hi Test User!"
  end
end

And("I click logout button") do
  find('div[data-testID="logoutButton"]').click
end
