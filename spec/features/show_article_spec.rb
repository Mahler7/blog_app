require "rails_helper"

RSpec.feature "Showing an article" do
  
  before do
    @user = User.create!(email: "john@example.com", password: "password")
    @user2 = User.create!(email: "fred@example.com", password: "password")
    @article = Article.create(title: "The first article", body: "Lorem ipsum dolor sit amet", user: @user)
  end

  scenario "To non-signed in user hide edit and delete buttons" do
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "To non-owner hide edit and delete buttons" do
    login_as(@user2)
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

end