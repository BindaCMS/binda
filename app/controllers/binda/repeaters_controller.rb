require_dependency "binda/application_controller"

module Binda
  class RepeatersController < ApplicationController
    before_action :set_repeater, only: [:show, :edit, :update, :destroy]

    # GET /repeaters
    def index
      @repeaters = Repeater.all
    end

    # GET /repeaters/1
    def show
    end

    # GET /repeaters/new
    def new
      @repeater = Repeater.new
    end

    # GET /repeaters/1/edit
    def edit
    end

    # POST /repeaters
    def create
      @repeater = Repeater.new(repeater_params)

      if @repeater.save
        redirect_to @repeater, params.merge(only_path: true, notice: 'Repeater was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /repeaters/1
    def update
      if @repeater.update(repeater_params)
        redirect_to @repeater, params.merge(only_path: true, notice: 'Repeater was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /repeaters/1
    def destroy
      @repeater.destroy
      # redirect_to repeaters_url, notice: 'Repeater was successfully destroyed.'
      if params['isAjax']
        head :ok
      else
        redirect_to :back, notice: 'Field group was successfully destroyed.'
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_repeater
        @repeater = Repeater.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def repeater_params
        params.require(:repeater).permit(:name, :slug)
      end
  end
end
