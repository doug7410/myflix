class SearchController < ApplicationController

  def index
    @search_prase = params[:search_term]
    @search = Video.search_by_title(@search_prase)

  end

end