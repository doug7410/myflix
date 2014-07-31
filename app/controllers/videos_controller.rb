class VideosController < ApplicationController

  before_action :require_user

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews.all
    @review = Review.new
  end

  def search
    @search_phrase = params[:search_term]
    @search_result = Video.search_by_title(@search_phrase)
  end

end