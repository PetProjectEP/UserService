require 'rails_helper'
require 'test_helpers/user_assets'

RSpec.describe "Sessions", type: :request do
  before :all do
    User.destroy_all
    Session.destroy_all

    @valid_nick, @valid_pw = "Nickname", "qwerty123"
    @user = UserAssets::get_valid_user_object(
      nickname: @valid_nick,
      password: @valid_pw,
      password_confirmation: @valid_pw
    )
    @user.save
  end

  describe "POST /sessions" do
    it "creates session with valid auth params (nickname + password)" do
      post "/sessions", params: { user: { nickname: @valid_nick, password: @valid_pw } }
      session = JSON.parse(response.body, symbolize_names: true)
      
      expect(session[:token]).not_to be_nil
      expect(session[:user_id]).to eq(@user[:id])
    end

    it "doesn't create session with wrong nickname" do
      post "/sessions", params: { user: { nickname: "Ahahahaha", password: @valid_pw } }
      session = JSON.parse(response.body, symbolize_names: true)

      expect(session[:token]).to be_nil
      expect(session[:error]).not_to be_nil
    end

    it "doesn't create session with wrong password" do
      post "/sessions", params: { user: { nickname: @valid_nick, password: "Ahahahaha" } }
      session = JSON.parse(response.body, symbolize_names: true)

      expect(session[:token]).to be_nil
      expect(session[:error]).not_to be_nil
    end
  end

  describe "DELETE /sessions/:id" do
    it "destroys session" do
      session = Session.create({ user_id: @user[:id] })
      delete "/sessions/#{session[:token]}"
      
      expect(Session.exists?(session[:token])).to be false
    end
  end

  describe "GET /sessions/:id" do
    it "returns user by given auth-token" do
      session = Session.create({ user_id: @user[:id] })
      get "/sessions/#{session[:token]}"

      user = JSON.parse(response.body, symbolize_names: true)
      expect(user[:id]).to eq(@user[:id])  
    end
  end
end
