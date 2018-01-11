require_dependency "binda/application_controller"

module Binda
  class VideosController < ApplicationController
    before_action :set_video, only: [:show, :edit, :update, :destroy, :remove_video]

    # GET /videos
    def index
      @videos = Video.all
    end

    # GET /videos/1
    def show
    end

    # GET /videos/new
    def new
      @video = Video.new
    end

    # GET /videos/1/edit
    def edit
    end

    # POST /videos
    def create
      @video = Video.new(video_params)

      if @video.save
        redirect_to video_path( @video.id ), notice: 'Video was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /videos/1
    def update
      if @video.update(video_params)
        redirect_to video_path( @video.id ), notice: 'Video was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /videos/1
    def destroy
      @video.destroy
      redirect_to videos_url, notice: 'Video was successfully destroyed.'
    end

    def remove_video
      @video.remove_video!
      if @video.save
        head :ok
      else
        render json: @video.errors.full_messages, status: 400
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_video
        @video = Video.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def video_params
        params.require(:video).permit( :video, :name )
      end
  end
end
