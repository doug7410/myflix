class Admin::VideosController < AdminsController
  def new
     @video = Video.new
  end

  def create

    @video = Video.new(params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url))
    if @video.save
      flash[:success] = "#{@video.title} has been created."
      redirect_to new_admin_video_path
    else
      flash[:warning] = "please correct the errors below"
      render :new
    end
  end
end
