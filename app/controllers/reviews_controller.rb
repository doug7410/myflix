class ReviewsController < ApplicationController

  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(review_params)
    @review.creator = current_user
    @review.video_id = @video.id
    if @review.save
      flash[:success] = "Your review has been added."
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.all
      render 'videos/show'
    end 
  end

private

  def review_params
    params.require(:review).permit(:body, :rating)
  end
end