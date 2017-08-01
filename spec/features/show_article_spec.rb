require "rails_helper"

RSpec.feature "Showing an article" do
  
  before do
    @user = User.create!(email: "john@example.com", password: "password")
    login_as(@user)
    @article = Article.create(title: "The first article", body: "Lorem ipsum dolor sit amet", user: @user)
  end

  scenario "A user shows an article" do
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))
  end
end