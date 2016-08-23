require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @user = User.create(email: "a@mail.com", password: "a", username: "a", role: 2)
    @unauthorized_user = User.create(email: "b@mail.com", password: "b", username: "b", role: 0 )
    @topic = Topic.create(title: "topicing", description: "topicing")
    @post = Post.create(title: "posting", body: "posting", topic_id: @topic.id, user_id: @user.id)
    end

  describe "render post index" do

    it "should render post index" do

      params = { topic_id: @topic.id }
      get :index, params: params

      expect(subject).to render_template(:index)
    end
  end

  describe "create post" do
    it "should flash if not logged in" do

      params = { topic_id: @topic.id, post: { title: "post title", body: "post body"} }
      post :create, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    #no authorization for post create

    it "should create post for authorized" do

      params = { topic_id: @topic.id, post: { title: "post title", body: "post body" } }
      post :create, xhr: true, params: params, session: { id: @user.id }
      post = Post.find_by(title: "post title")

      expect(post).to be_present
      expect(Post.count).to eql(2)
      expect(post.body).to eql("post body")
      expect(flash[:success]).to eql("You've created a new post.")
    end
  end

end
