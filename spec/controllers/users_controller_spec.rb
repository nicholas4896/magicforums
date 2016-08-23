require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) do
    @user = User.create(email: "1@gmail.com", password: "password", username: "1")
    @unauthorized_user = User.create(email: "2@gmail.com", password: "password", username: "2")
  end

  describe "render new" do
    it "should render new" do

      get :new
      expect(subject).to render_template(:new)
      expect(assigns[:user]).to be_present
    end
  end

  describe "create user" do
    it "should create new user" do

      params = { user: { email: "sexy@gmail.com", username: "sexy", password: "password"} }
      post :create, params: params

      user = User.find_by(email: "sexy@gmail.com")

      expect(User.count).to eql(3)
      expect(user.email).to eql("sexy@gmail.com")
      expect(user.username).to eql("sexy")
      expect(flash[:success]).to eql("You've created a new user.")
    end
  end

  describe "edit user" do
    it "should redirect if not logged in" do
# binding.pry
      params = { id: @user.id }
      get :edit, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @user.id }
      get :edit, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit" do
      params = { id: @user.id }
      get :edit, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(subject).to render_template(:edit)
      expect(current_user).to be_present
    end
  end

  describe "update user" do

    it "should redirect if not logged in" do
      params = { id: @user.id, user: { email: "new@gmail.com", username: "new" } }
      patch :update, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @user.id, user: { email: "new@gmail.com", username: "new" } }
      patch :update, params: params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
  end

    it "should update user" do
      params = { id: @user.id, user: { email: "new@gmail.com", username: "new", password: "new" } }
      patch :update, params: params, session: { id: @user.id }
      @user.reload
      current_user = subject.send(:current_user).reload
# binding.pry
      expect(current_user.email).to eql("new@gmail.com")
      expect(current_user.username).to eql("new")
      expect(current_user.authenticate("new")).to eql(@user)
    end
  end

end
