class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items 
  end

  def create
    video = Video.find(params[:video_id])
    list_order = current_user.queue_items.size + 1
      @queue_item = QueueItem.new(video: Video.find(video.id), user: current_user, list_order: list_order)

    if current_user.queue_items.where(video: video).present?
      flash[:warning] = "#{video.title} is allready in your queue."
      redirect_to video
    else
      @queue_item.save
      redirect_to my_queue_path
    end
  end
end