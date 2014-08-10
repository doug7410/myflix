class ReviewsController < ApplicationController

  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(review_params.merge!(creator: current_user, video: @video))
    if @review.save
      flash[:success] = "Your review has been added."
      redirect_to video_path(@video)
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end 
  end

private

  def review_params
    params.require(:review).permit(:body, :rating)
  end
end