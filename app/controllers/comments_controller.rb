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
      flash[:success] = "You've created a new comment."

      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash[:danger] = @comment.errors.full_messages

      redirect_to topic_post_comments_path
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
      flash[:success] = "You've updated the comment."

      redirect_to topic_post_comments_path
    else
      flash[:danger] = @comment.errors.full_messages

      redirect_to edit_topic_post_comment_path(@comment)
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic

    if @comment.destroy
      redirect_to topic_post_comments_path
    end
  end

private

  def comment_params
    params.require(:comment).permit(:body, :image)
  end

end
