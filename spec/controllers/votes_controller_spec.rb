require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  before(:all) do
    @user = User.create(email: "a@mail.com", password: "a", username: "a", role: 2)
    @user2 = User.create(email: "b@mail.com", password: "b", username: "b", role: 0)
    @unauthorized_user = User.create(email: "c@mail.com", password: "c", username: "c", role: 0 )
    @topic = Topic.create(title: "topic title", description: "topic description", user_id: @user.id)
    @post = Post.create(title: "post title", body: "post body", topic_id: @topic.id, user_id: @user.id)
    @comment = Comment.create(body:"comment body", post_id: @post.id, user_id: @user.id)
  end

  describe "can't vote if not logged in" do

    it "should flash if not logged in" do

      params = {comment_id: @comment.id}
      post :upvote, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end
  end

  describe "upvote a comment" do
    it "should upvote for admin" do

      params = { comment_id: @comment.id }
      post :upvote, xhr: true, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(flash[:success]).to eql("Upvoted")
    end

    it "should upvote for user" do

      params = { comment_id: @comment.id }
      post :upvote, xhr: true, params: params, session: {id: @user2.id}

      expect(Vote.count).to eql(1)
      expect(flash[:success]).to eql("Upvoted")
    end

    it "shouldn't upvote more than once" do

      @upvote = Vote.create(comment_id: @comment.id, user_id: @user2.id)
      expect(Vote.count).to eql(1)

      params = { comment_id: @comment.id }
      post :upvote, xhr: true, params: params, session: { id: @user2.id }

      expect(Vote.count).to eql(1)
    end
  end

  describe "downvote a comment" do
    it "should downvote for admin" do

      params = {comment_id: @comment.id}
      post :downvote, xhr: true, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(flash[:success]).to eql("Downvoted")
    end

    it "should downvote for user" do

      params = {comment_id: @comment.id}
      post :downvote, xhr: true, params: params, session: {id: @user2.id}
# binding.pry
      expect(Vote.count).to eql(1)
      expect(flash[:success]).to eql("Downvoted")
    end

    it "shouldn't downvote more than once" do

      @downvote = Vote.create(comment_id: @comment.id, user_id: @user2.id)
      expect(Vote.count).to eql(1)

      params = {comment_id: @comment.id}
      post :downvote, xhr: true, params: params, session: {id: @user2.id}

      expect(Vote.count).to eql(1)
    end
  end

end
