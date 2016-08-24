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

      params = { reset: { email: "a@amail.com" } }
      post :create, params: params

      @user.reload

      expect(ActionMailer::Base.deliveries.count).to eql(1)

      expect(@user.password_reset_token).to be_present
      expect(@user.password_reset_at).to be_present
      expect(subject).to redirect_to(new_password_reset_path)
    end
  end


    describe "edit password" do

    end

    describe "update password" do

    end

end
