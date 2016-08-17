class TopicsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topics = Topic.all.order(created_at: :desc).page (params[:page])
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
    @topic = Topic.find_by(id: params[:id])
    #binding.pry
    authorize @topic
    if @topic.update(topic_params)
      flash.now[:success] = "You've updated the topic."
    else
      flash.now[:danger] = @topic.errors.full_messages
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:id])
    authorize @topic
    if @topic.destroy
      flash.now[:success] = "You've deleted the topic."
    #else
    #  flash.now[:danger] = @topic.errors.full_messages
    end
  end


private

  def topic_params
    params.require(:topic).permit(:title, :description, :image)
  end

end
