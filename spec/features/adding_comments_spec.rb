require 'rails_helper'

RSpec.feature "Adding Reviews to Articles"  do
  before do
    @user = User.create(email: "john@example.com", password: "password")
    @user2 = User.create(email: "fred@example.com", password: "password")
    @article = Article.create!(title: "Title One", body: "Body of article one", user: @user)
  end

  scenario "permits a signed in user to right a review" do
    login_as(@user)
    visit '/'
    click_link @article.title
    fill_in "New Comment", with: "An amazing article"
    click_button "Add Comment"
    expect(page).to have_content("Comment has been created")
    expect(page).to have_content("An amazing article")
    expect(current_path).to eq(article_path(@article.id))
  end
end