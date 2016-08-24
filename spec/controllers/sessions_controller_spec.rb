require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "render new" do
    it "should render new" do

      get :new

      expect(subject).to render_template(:new)
    end
  end

  describe "create session" do

    before(:all) do

      @user = User.create(email: "a@mail.com", password: "a", username: "a")
    end

    it "should create session for user" do

      params = { user: { email: "a@mail.com", password: "a" } }
      post :create, params: params

      current_user = subject.send(:current_user)
      user = User.find_by(email: "a@mail.com")

      expect(current_user).to be_present
      expect(flash[:success]).to eql("Welcome back #{current_user.username}")
    end

    it "should deny if login error" do

      params = { user: { email: "a@mail.com", password: "b" } }
      post :create, params: params

      current_user = subject.send(:current_user)

      expect(current_user).not_to be_present
      expect(flash[:danger]).to eql("Error logging in")
    end
  end

end
