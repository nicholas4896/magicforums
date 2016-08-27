require 'rails_helper'

 RSpec.describe CommentsController, type: :controller do

   before(:all) do
     @topic = create(:topic)
     @admin = create(:user, :admin, :sequenced_email, :sequenced_username)
     @user = create(:user)
     @post = create(:post, :sequenced_title, :sequenced_body, topic_id: @topic.id, user_id: @user.id)
     @unauthorized_user = create(:user, :sequenced_email, :sequenced_username)
     5.times{create(:comment, :sequenced_body, post_id: @post.id, user_id: @user.id)}
    #  @user = User.create(email: "a@mail.com", password: "a", username: "a", role: 2)
    #  @user2 = User.create(email: "b@mail.com", password: "b", username: "b", role: 0)
    #  @unauthorized_user = User.create(email: "c@mail.com", password: "c", username: "c", role: 0 )
    #  @topic = Topic.create(title: "topic title", description: "topic description", user_id: @user.id)
    #  @post = Post.create(title: "post title", body: "post body", topic_id: @topic.id, user_id: @user.id)
    #  @comment = Comment.create(body:"comment body", post_id: @post.id, user_id: @user.id)
  end

  describe "comment index" do

    it "should render index" do

      params = { topic_id: @topic.id, post_id: @post.id }
      get :index, params: params

      expect(subject).to render_template(:index)
    end
  end

  describe "create comment" do

    it "should flash if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, comment: { body: "comment body"} }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render create for admin" do

      params = { topic_id: @topic.id, post_id: @post.id, comment:{body: "comment body" } }
      post :create, xhr: true, params: params, session: {id: @admin.id}

      comment = Comment.find_by(body: "comment body")

      expect(comment.body).to eql("comment body")
      expect(Comment.count).to eql(6)
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  #
    it "should render create for user" do

      params = { topic_id: @topic.id, post_id: @post.id, comment:{body: "comment body" } }
      post :create, xhr: true, params: params, session: {id: @user.id}

      comment = Comment.find_by(body:"comment body")

      expect(Comment.count).to eql(6)
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  end

  describe "edit comment" do

    it "should flash if not logged in" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }
      get :edit, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }

      get :edit, xhr: true, params:params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit for comment owner" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }

      get :edit, xhr: true, params: params, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end

    it "should render edit for admin" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id }

      get :edit, xhr: true, params: params, session: { id: @admin.id }

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to render_template(:edit)
    end
  end

  describe "update comment" do

    it "should flash if not logged in" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update for comment owner" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params, session: { id: @user.id }

      @comment.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(@comment.body).to eql("Updated Comment")
      expect(flash[:success]).to eql("You've updated the comment.")
    end

    it "should update for admin" do

      @comment = Comment.first
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params, session: { id: @admin.id }

      @comment.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(@comment.body).to eql("Updated Comment")
      expect(flash[:success]).to eql("You've updated the comment.")
    end
  end

  describe "destroy topic" do

    it "should flash if not logged in" do

      @comment = Comment.first
      delete :destroy, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @comment = Comment.first
      delete :destroy, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should destroy for comment owner" do

      @comment = Comment.first
      delete :destroy, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }, session: { id: @user.id }

      comment = Comment.find_by(id: @comment.id)

      expect(comment).not_to be_present
      expect(flash[:success]).to eql("You've deleted the comment.")
    end

    it "should destory for admin" do

      @comment = Comment.first
      delete :destroy, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }, session: { id: @admin.id }
      comment = Comment.find_by(id: @comment.id)

      expect(comment).not_to be_present
      expect(flash[:success]).to eql("You've deleted the comment.")
    end
  end

end
