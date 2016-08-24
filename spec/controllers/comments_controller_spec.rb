require 'rails_helper'

 RSpec.describe CommentsController, type: :controller do

   before(:all) do
     @user = User.create(email: "a@mail.com", password: "a", username: "a", role: 2)
     @user2 = User.create(email: "b@mail.com", password: "b", username: "b", role: 0)
     @unauthorized_user = User.create(email: "c@mail.com", password: "c", username: "c", role: 0 )
     @topic = Topic.create(title: "topic title", description: "topic description", user_id: @user.id)
     @post = Post.create(title: "post title", body: "post body", topic_id: @topic.id, user_id: @user.id)
     @comment = Comment.create(body:"comment body", post_id: @post.id, user_id: @user.id)
  end

  describe "comment index" do

    it "should render index" do

      params = { topic_id: @topic.id, post_id: @post.id, comment_id: @comment.id  }
      get :index, params: params

      expect(Comment.count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create comment" do

    it "should flash if not logged in" do

      params = { topic_id: @topic.id, post_id: @post.id, comment_id: @comment.id  }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render create for admin" do

      params = { topic_id: @topic.id, post_id: @post.id, comment:{body: "comment body2" } }
      post :create, xhr: true, params: params, session: {id: @user.id}

      new_comment = Comment.find_by(body:"comment body2")
      expect(new_comment.body).to eql("comment body2")
      expect(Comment.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  #
    it "should render create for user" do

      params = { topic_id: @topic.id, post_id: @post.id, comment:{body: "comment body2" } }
      post :create, xhr: true, params: params, session: {id: @user2.id}

      new_comment = Comment.find_by(body:"comment body2")
      expect(new_comment.body).to eql("comment body2")
      expect(Comment.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  end

  describe "edit comment" do

    it "should flash if not logged in" do

      @comment = Comment.create(body: "comment sexybody")
      get :edit, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      get :edit, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }, session: { id: @user2.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit for comment owner" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      get :edit, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end

    it "should render edit for admin" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      get :edit, xhr: true, params: { topic_id: @topic.id, post_id: @post.id, id: @comment.id }, session: { id: @user.id }

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end
  end

  describe "update comment" do

    it "should flash if not logged in" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params, session: { id: @user2.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update for comment owner" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user2.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      patch :update, xhr: true, params: params, session: { id: @user2.id }

      @comment.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user2)
      expect(@comment.body).to eql("Updated Comment")
      expect(flash[:success]).to eql("You've updated the comment.")
    end

    it "should update for admin" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user2.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: { body: "Updated Comment" } }
      patch :update, xhr: true, params: params, session: { id: @user.id }

      @comment.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(@comment.body).to eql("Updated Comment")
      expect(flash[:success]).to eql("You've updated the comment.")
    end
  end

  describe "destroy topic" do

    it "should flash if not logged in" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      delete :destroy, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should flash if unauthorized" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment:{ body: "Updated Comment" } }
      delete :destroy, xhr: true, params: params, session: { id: @user2.id }

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should destroy for comment owner" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id}
      delete :destroy,xhr: true, params: params, session: {id: @user.id}

      comment = Comment.find_by(id: @comment.id)

      expect(comment).not_to be_present
      expect(flash[:success]).to eql("You've deleted the comment.")
    end

    it "should destory for admin" do

      @comment = Comment.create(body: "comment sexybody", post_id: @post.id, user_id: @user2.id)
      params = { topic_id: @topic.id, post_id: @post.id, id: @comment.id}
      delete :destroy,xhr: true, params: params, session: {id: @user.id}

      comment = Comment.find_by(id: @comment.id)

      expect(comment).not_to be_present
      expect(flash[:success]).to eql("You've deleted the comment.")
    end
  end

end
