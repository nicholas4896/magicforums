require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @user = User.create(email: "a@gmail.com", password: "password", username: "a", role: 2)
    @unauthorized_user = User.create(email: "b@gmail.com", password: "password", username: "b")
    @params = { topic: { title: "testing", description: "testing" } }
    @topic = Topic.create(title: "testing edit", description: "testing edit")
  end

  describe "render index" do
    it "should render index" do
      get :index

      expect(subject).to render_template(:index)
    end
  end

  describe "create topic" do
    it "should redirect if not logged it" do
      post :create, params: @params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if not authorized" do
      post :create, params: @params, session: { id: @unauthorized_user.id }

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should create new topic" do
      post :create, xhr: true, params: @params, session: { id: @user.id }
      topic = Topic.find_by(title: "testing")

      expect(topic).to be_present
      expect(Topic.count).to eql(2)
      expect(topic.description).to eql("testing")
      expect(flash[:success]).to eql("You've created a new topic.")
    end
  end

  describe "edit topic" do
    it "should flash if not logged in" do
#AJAX action no redirect
      get :edit, xhr: true, params: { id: @topic.id }

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if not authorized" do
      get :edit, xhr: true, params: { id: @topic.id }, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit for admin" do
      get :edit, xhr: true, params: { id: @topic.id }, session: { id: @user.id }

      expect(subject).to render_template(:edit)
    end
  end

  describe "update topic" do

    it "should flash when not logged in" do
      patch :update, xhr: true, params: @params.merge(id: @topic.id)

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash when unauthorized" do
      patch :update, xhr: true, params: @params.merge(id: @topic.id), session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update topic for admin" do
      patch :update, xhr: true, params: @params.merge(id: @topic.id), session: { id: @user.id }

      @topic.reload

      expect(@topic.title).to eql ("testing")
      expect(@topic.description).to eql ("testing")
      # expect( { @topic.title, @topic.description }.length) >= 5
      expect(flash[:success]).to eql("You've updated the topic.")
    end
  end

  describe "destroy topic" do
    it "should flash when not logged in" do
      delete :destroy, xhr: true, params: { id: @topic.id }

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash when unauthorized" do
      delete :destroy, xhr: true, params: { id: @topic.id }, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete for admin" do
      delete :destroy, xhr: true, params: { id: @topic.id }, session: { id: @user.id }

      expect(flash[:success]).to eql("You've deleted the topic.")
      topic = Topic.find_by(id: @topic.id)
      expect(topic).not_to be_present
    end
  end

end
