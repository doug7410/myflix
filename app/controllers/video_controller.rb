class VideoController < ApplicationController

  before_action :require_user

  def show
    @video = Video.find(params[:id])
  end

  def search
    @search_prase = params[:search_term]
    @search = Video.search_by_title(@search_prase)
  end

end