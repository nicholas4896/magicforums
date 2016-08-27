require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do

  before(:all) do

    @user = User.create(email: "a@mail.com", password: "a", username: "a")
  end

  describe "render new" do
    it "should render new" do

      get :new

      expect(subject).to render_template(:new)
    end
  end

  describe "create reset" do

    it "should set token and date" do

      params = { reset: { email: "a@mail.com" } }
      post :create, params: params

      @user.reload

      expect(ActionMailer::Base.deliveries.count).to eql(1)

      expect(@user.password_reset_token).to be_present
      expect(@user.password_reset_at).to be_present
      expect(subject).to redirect_to(new_password_reset_path)
      expect(flash[:success]).to eql("We've sent you instructions on how to reset your password")
    end

    it "should error if no such user" do

      params = { reset: { email: "b@mail.com" } }
      post :create, params: params

      @user.reload

      expect(@user.password_reset_token).not_to be_present
      expect(@user.password_reset_at).not_to be_present
      expect(subject).to redirect_to(new_password_reset_path)
      expect(flash[:danger]).to eql("User does not exist")
    end
  end

    describe "edit password" do

      it "should edit password" do

        params = { id: "resettoken"}
        get :edit, xhr: true, params: params

        expect(assigns[:token]).to eql("resettoken")
      end
    end

    describe "update password" do

      it "should update user's password" do

        params = { reset: { email: "a@mail.com" } }
        post :create, xhr: true, params: params

        @user.reload

        params = { id: @user.password_reset_token, user: { password: "b" } }
        patch :update, params: params

        @user.reload

        user = @user.authenticate("b")

        expect(user).to be_present
        expect(user.password_reset_token).to be_nil
        expect(user.password_reset_at).to be_nil
        expect(flash[:success]).to eql("Password updated, you may log in now")
        expect(subject).to redirect_to(root_path)
      end

      it "should err if token is invalid" do

        params = { reset: { email: "a@mail.com" } }
        post :create, xhr: true, params: params

        edit_params = { id: "wrongtoken" }
        params = { id: "wrongtoken", user: { password: "b" } }
        patch :update, params: params

        @user.reload

        user = @user.authenticate("b")

        expect(user).to eql(false)
        expect(flash[:danger]).to eql("Error, token is invalid or has expired")
        expect(subject).to redirect_to(edit_password_reset_path)
      end
    end

end
