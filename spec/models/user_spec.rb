require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.new(:first_name => "first", :last_name => "last", :email => "a@a.com", :password => "111", :password_confirmation => "111")
  end

  describe 'Validations' 

    it "should successfully saves a user given a first name, last name, email, password and password confirmation" do
      @user.save
      expect(@user).to be_valid
      expect(@user.errors.full_messages).to be_empty
    end

    it "should fail to create a user when first_name is not given" do
      @user.first_name = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include "First name can't be blank"
    end
    
    it "should fail to create a user when last_name is not given" do
      @user.last_name = nil
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include "Last name can't be blank"
    end

    describe 'email' do
      it "should fail to create a user when email is not given" do
        @user.email = nil
        @user.save
        expect(@user).to_not be_valid
        expect(@user.errors.full_messages).to include "Email can't be blank"
      end

      it "should fail to create a user when email already exists" do
        user2 = User.new(:first_name => "first2", :last_name => "last2", :email => "b@b.com", :password => "222", :password_confirmation => "222")
        @user.save
        user2.save
        expect(user2).to_not be_valid
        expect(user2.errors.full_messages).to include "Email has already been taken"
      end
    end

    describe 'password' do
      it "should fail to create a user when password is not given" do
        @user.password = nil
        @user.save
        expect(@user).to_not be_valid
        expect(@user.errors.full_messages).to include "Password can't be blank"
      end

      it "should fail to create a user when password_confirmation is not given" do
        @user.password_confirmation = nil
        @user.save
        expect(@user).to_not be_valid
        expect(@user.errors.full_messages).to include "Password confirmation can't be blank"
      end

      it "should fail to create a user when password and password_confirmation do not match" do
        @user.password_confirmation = "asdasdasd"
        @user.save
        expect(@user).to_not be_valid
        expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
      end

      it "should fail to create a user when password and password_confirmation are less than the required length" do
        @user.password = "1"
        @user.save
        expect(@user).to_not be_valid
        expect(@user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
      end
    end

    describe '.authenticate_with_credentials' do
      it "should return an instance of the user if successfully authenticated" do
        @user.save
        authenticated_user = User.authenticate_with_credentials('a@a.com', '111')
        expect(authenticated_user.email).to eq @user.email
      end

      it "should return an instance of the user regardless of email case" do
        @user.save
        authenticated_user = User.authenticate_with_credentials('A@a.com', '111')
        expect(authenticated_user.email).to eq @user.email
      end

      it "should return an instance of the user regardless of trailing spaces before and/or after email" do
        @user.save
        authenticated_user = User.authenticate_with_credentials('  a@a.com  ', '1')
        expect(authenticated_user.email).to eq @user.email
      end

      it "should return nil if unsuccessfully authenticated due to incorrect password" do
        @user.save
        authenticated_user = User.authenticate_with_credentials('a@a.com', 'q2e1dq1dqw')
        expect(authenticated_user).to be nil
      end
      
      it "should return nil if unsuccessfully authenticated due to non-existing user" do
        @user.save
        authenticated_user = User.authenticate_with_credentials('doesnotexist@a.com', '1123')
        expect(authenticated_user).to be nil
      end
    end
  end
end