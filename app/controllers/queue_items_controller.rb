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
    current_user.normalize_queue_item_postitions
    redirect_to my_queue_path
  end

  def update
    begin 
      update_queue_items
      current_user.normalize_queue_item_postitions
    rescue
      flash[:warning] = "Invalid list order"
      redirect_to my_queue_path
      return
    end
    redirect_to my_queue_path
  end

private

def update_queue_items
  ActiveRecord::Base.transaction do
    params[:queue_items].each do |queue_item_data|
      queue_item = QueueItem.find(queue_item_data[:id])
      if queue_item.user == current_user
        queue_item.update_attributes!(list_order: queue_item_data[:list_order])
      end
    end
  end
end

end