require "rails_helper"

RSpec.describe "Articles", type: :request do
  
  before do
    @user = User.create(email: "john@example.com", password: "password")
    @user2 = User.create(email: "fred@example.com", password: "password")
    @article = Article.create!(title: "Title One", body: "Body of article one", user: @user)
  end

  describe 'DELETE/articles/:id' do
    context 'with non-signed in user' do
      before { delete "/articles/#{@article.id}" }
      it "redirects to the sign in page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in user who is non-owner' do
      before do 
        login_as(@user2)
        delete "/articles/#{@article.id}"
      end
      it "redirects to the home page" do
        expect(response.status).to eq 302
        flash_message = "You can only delete your article"
        expect(flash[:danger]).to eq flash_message
      end
    end

    context 'with signed in user as owner successful delete' do
      before do
        login_as(@user)
        delete "/articles/#{@article.id}/"
      end
      it "successfully deletes article" do
        expect(response.status).to eq 302
        expect(response).to redirect_to(articles_path)
      end
    end
  end

  describe 'GET/articles/:id/edit' do
    context 'with non-signed in user' do
      before { get "/articles/#{@article.id}/edit" }
      it "redirects to the sign in page" do
        expect(response.status).to eq 302
        flash_message = "You need to sign in or sign up before continuing."
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in user who is non-owner' do
      before do 
        login_as(@user2)
        get "/articles/#{@article.id}/edit"
      end
      it "redirects to the home page" do
        expect(response.status).to eq 302
        flash_message = "You can only edit your article"
        expect(flash[:alert]).to eq flash_message
      end
    end

    context 'with signed in user as owner successful edit' do
      before do
        login_as(@user)
        get "/articles/#{@article.id}/edit"
      end
      it "successfully edits article" do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /articles/:id' do
    context 'with exisiting article' do
      before { get "/articles/#{@article.id}" }

      it "handles exisiting article" do
        expect(response.status).to eq(200)
      end
    end

    context 'with non-exisiting article' do
      before { get "/articles/xxxx" }

      it "handles non-existing article" do
        expect(response.status).to eq(302)
        flash_message = "The article you are looking for could not be found"
        expect(flash[:alert]).to eq(flash_message)
      end
    end
  end
end