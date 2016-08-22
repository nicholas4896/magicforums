require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @user = User.create(email: "admin@gmail.com", password: "password", username: "admin", role: "admin")
    @unauthorized_user = User.create(email: "user@gmail.com", password: "password", username: "user")
    @params = { topic: { title: "testing", description: "testing", image: "nil" } }
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

      post :create, params: @params, session: { id: @user.id }

      topic = Topic.find_by(title: "testing")
binding.pry
      expect(Topic.count).to eql(1)
      expect(topic.title).to eql("testing")
      expect(topic.description).to eql("testing")
      expect(topic).to be_present
      expect(flash[:success]).to eql("You've created a new topic.")
    end
  end

end
