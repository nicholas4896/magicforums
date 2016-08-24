require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @user = User.create(email: "a@mail.com", password: "a", username: "a", role: 2)
    @user2 = User.create(email: "b@mail.com", password: "b", username: "b", role: 2)
    @unauthorized_user = User.create(email: "b@mail.com", password: "b", username: "b", role: 0 )
    @topic = Topic.create(title: "topic title", description: "topic description", user_id: @user.id)
    @post = Post.create(title: "post title", body: "post body", user_id: @user.id)
    @params = { topic_id: @topic.id, post: {title: "post title", body: "post body", user_id: @user.id } }
    end

  describe "render post index" do

    it "should render post index" do

      get :index, params: @params

      expect(subject).to render_template(:index)
    end
  end

  describe "create post" do

    it "should flash if not logged in" do

      post :create, params: @params

      expect(flash[:danger]).to eql("You need to login first")
    end

    #no authorization for post create, all can create

    it "should create post for authorized" do

      post :create, xhr: true, params: @params, session: { id: @user.id }
      post = Post.find_by(title: "post title")

      expect(post).to be_present
      expect(Post.count).to eql(2)
      expect(post.body).to eql("post body")
      expect(flash[:success]).to eql("You've created a new post.")
    end
  end

  describe "edit post" do
    it "should flash if not logged in" do

      @post = Post.create(title: "post title", body: "post body")
      get :edit, xhr: true, params: { topic_id: @topic.id, id: @post.id }

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if not post owner/admin" do

      @post = Post.create(title: "post title", body: "post body")
      get :edit, xhr: true, params: { topic_id: @topic.id, id: @post.id}, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit for post owner" do

      @post = Post.create(title: "post title", body: "post body", user_id: @user.id)
      get :edit, xhr: true, params: { topic_id: @topic.id, id: @post.id}, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end

    it "should render edit for admin" do

      @post = Post.create(title: "post title", body: "post body", user_id: @user.id)
      get :edit, xhr: true, params: { topic_id: @topic.id, id: @post.id}, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end
  end

  describe "update post" do
    it "should flash if not logged in" do

      @post = Post.create(title: "post title", body: "post body")
      patch :update, xhr: true, params: { topic_id: @topic.id, id: @post.id}

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @post = Post.create(title: "post title", body: "post body")
      patch :update, xhr: true, params: { topic_id: @topic.id, id: @post.id}, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post for owner/admin" do

      @post = Post.create(title: "post title", body: "post body")
      patch :update, xhr: true, params: { topic_id: @topic.id, id: @post.id, post: { title: "updated title", body: "updated body" } }, session: { id: @user.id }

      @post.reload

      expect(@post.title).to eql("updated title")
      expect(@post.body).to eql("updated body")
      expect(flash[:success]).to eql("You've updated the post.")
    end
  end

  describe "delete post" do
    it "should flash if not logged in" do

      @post = Post.create(title: "post title", body: "post body")
      delete :destroy, xhr: true, params: { topic_id: @topic.id, id: @post.id}

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @post = Post.create(title: "post title", body: "post body")
      delete :destroy, xhr: true, params: { topic_id: @topic.id, id: @post.id}, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should delete for admin/ownder" do

      @post = Post.create(title: "post title", body: "post body")
      delete :destroy, xhr: true, params: { topic_id: @topic.id, id: @post.id }, session: { id: @user.id }

      post = Post.find_by(id: @post.id)

      expect(flash[:success]).to eql("You've deleted the post.")
      expect(post).not_to be_present
    end
  end

end
