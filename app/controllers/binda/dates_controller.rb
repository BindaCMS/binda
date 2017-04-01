require_dependency "binda/application_controller"

module Binda
  class DatesController < ApplicationController
    before_action :set_date, only: [:show, :edit, :update, :destroy]

    # GET /dates
    def index
      @dates = Date.all
    end

    # GET /dates/1
    def show
    end

    # GET /dates/new
    def new
      @date = Date.new
    end

    # GET /dates/1/edit
    def edit
    end

    # POST /dates
    def create
      @date = Date.new(date_params)

      if @date.save
        redirect_to @date, notice: 'Date was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /dates/1
    def update
      if @date.update(date_params)
        redirect_to @date, notice: 'Date was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /dates/1
    def destroy
      @date.destroy
      redirect_to dates_url, notice: 'Date was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_date
        @date = Date.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def date_params
        params.require(:date).permit(:date)
      end
  end
end
