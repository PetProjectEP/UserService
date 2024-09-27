require 'rails_helper'
require 'test_helpers/user_assets'

RSpec.describe User, type: :model do
  subject(:user) { UserAssets::get_valid_user_object }

  describe "validations," do
    it "allows creation of user with valid params" do
      expect(user.valid?).to be true  
    end

    it "doesn't allow creation of user if its nickname is already taken" do
      UserAssets::get_valid_user_object.save
      expect(user.valid?).to be false
    end

    it "doesn't allow creation of user if its nickname is not in (6..32)" do
      user[:nickname] = (1..5).map { (65 + rand(26)).chr }.join
      expect(user.valid?).to be false

      user[:nickname] = (1..33).map { (65 + rand(26)).chr }.join
      expect(user.valid?).to be false
    end

    it "doesn't allow creation of user if its name is not in (1..32)" do
      user[:name] = ""
      expect(user.valid?).to be false

      user[:name] = (1..33).map { (65 + rand(26)).chr }.join
      expect(user.valid?).to be false
    end

    it "doesn't allow creation of user if its surname is not in (1..32)" do
      user[:surname] = ""
      expect(user.valid?).to be false

      user[:surname] = (1..33).map { (65 + rand(26)).chr }.join
      expect(user.valid?).to be false
    end

    it "doesn't allow creation of user if its password is not in (6..32)" do
      pw = (1..5).map { (65 + rand(26)).chr }.join
      user = UserAssets::get_valid_user_object password: pw, password_confirmation: pw
      expect(user.valid?).to be false

      pw = (1..33).map { (65 + rand(26)).chr }.join
      user = UserAssets::get_valid_user_object password: pw, password_confirmation: pw
      expect(user.valid?).to be false
    end

    it "doesn't allow creation of user if its password doesn't match confirmation" do
      user = UserAssets::get_valid_user_object password: "qwerty123", password_confirmation: "qwe123ty"
      expect(user.valid?).to be false
    end
  end
end
