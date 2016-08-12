class TopicsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topics = Topic.all.order(created_at: :desc)
    @topic =Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)
    @new_topic = Topic.new
    authorize @topic

    if @topic.save
      flash.now[:success] = "You've created a new topic."
    else
      flash.now[:danger] = @topic.errors.full_messages
    end
  end

  def edit
    @topic = Topic.find_by(id: params[:id])
    authorize @topic
  end

  def update
    @topic = topic.find_by(id: params[:id])
    authorize @topic

    if @topic.update(topic_params)
      flash.now[:success] = "You've updated the topic."
    else
      flash[:danger] = @topic.errors.full_messages
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:id])
    authorize @topic
    if @topic.destroy
      flash.now[:success] = "You've updated the topic."
      redirect_to topics_path
    else
      redirect_to topics_path(@topic)
    end
  end

private

  def topic_params
    params.require(:topic).permit(:title, :description, :image)
  end

end
