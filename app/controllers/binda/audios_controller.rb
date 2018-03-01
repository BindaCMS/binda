require_dependency "binda/application_controller"

module Binda
  class AudiosController < ApplicationController
    before_action :set_audio, only: [:show, :edit, :update, :destroy, :remove_audio]

    # GET /audios
    def index
      @audios = Audio.all
    end

    # GET /audios/1
    def show
    end

    # GET /audios/new
    def new
      @audio = Audio.new
    end

    # GET /audios/1/edit
    def edit
    end

    # POST /audios
    def create
      @audio = Audio.new(audio_params)

      if @audio.save
        redirect_to audio_path( @audio.id ), notice: 'Audio was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /audios/1
    def update
      if @audio.update(audio_params)
        redirect_to audio_path( @audio.id ), notice: 'Audio was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /audios/1
    def destroy
      @audio.destroy
      redirect_to audios_url, notice: 'Audio was successfully destroyed.'
    end

    def remove_audio
      @audio.remove_audio!
      if @audio.save
        head :ok
      else
        render json: @audio.errors.full_messages, status: 400
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_audio
        @audio = Audio.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def audio_params
        params.require(:audio).permit( :audio, :name )
      end
  end
end
