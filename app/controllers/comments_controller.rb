class CommentsController < ApplicationController

  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @post = @topic.posts.find_by(id: params[:post_id])
    @comments = @post.comments.order("created_at DESC")
  end

  def new
    @topic = Topic.find_by(id: params[:topic_id])
    @post = @topic.posts.find_by(id: params[:post_id])
    @comment = Comment.new
  end

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @post = @topic.posts.find_by(id: params[:post_id])
    @comment = Comment.new(comment_params.merge(post_id: params[:post_id]))

    if @comment.save
      redirect_to topic_post_comments_path(@topic, @post)
    else
      render new_topic_post_comment_path
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic

    if @comment.update(comment_params)
      redirect_to topic_post_comments_path
    else
      redirect_to edit_topic_post_comment_path(@comment)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = Post.find_by(id: params[:id])
    @topic = @post.topic

    if @comment.destroy
      redirect_to topic_post_comments_path(@comment)
    end
  end

private

  def comment_params
    params.require(:comment).permit(:body)
  end

end