class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items 
  end

  def create
    video = Video.find(params[:video_id])
    add_queue_item!(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.queue_items.each_with_index do |item, index|
      item.list_order = index + 1
      item.save
    end

    redirect_to my_queue_path
  end

  private

  def add_queue_item!(video)
    QueueItem.create(video: video, user: current_user, list_order: list_order) unless current_user_queued_video?(video)
  end

  def list_order 
    current_user.queue_items.size + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.where(video: video).present?
  end
end