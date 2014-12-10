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

  def show
    @video = Video.find(params[:id])
    render :show
  end

  def update
    @video = Video.find(params[:id])
    if @video.update(params.require(:video).permit!)
      flash[:success] = 'The video has been updated.'
      redirect_to admin_video_path(@video)
    else
      flash[:danger] = "please fix the errors below"
      render :show
    end
  end

end
