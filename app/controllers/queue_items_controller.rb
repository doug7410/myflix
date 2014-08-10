class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items 
  end

  def create
    video = Video.find(params[:video_id])
    current_user.add_queue_item!(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.queue_items.each_with_index do |item, index|
      item.update(list_order: index + 1)
    end

    redirect_to my_queue_path
  end

  def update
    queue_items = params[:queue_items]
    queue_items.each do |queue_item|
      QueueItem.find(queue_item[:id]).update(list_order: queue_item[:list_order])
    end

    current_user.queue_items.each_with_index do |item, index|
      item.update(list_order: index + 1)
    end
    
    redirect_to my_queue_path
  end

  
end