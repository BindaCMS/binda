require_dependency "binda/application_controller"

module Binda
  class TextsController < ApplicationController
    before_action :set_text, only: [:show, :edit, :update, :destroy]

    # GET /texts
    def index
      @texts = Text.all
    end

    # GET /texts/1
    def show
    end

    # GET /texts/new
    def new
      @text = Text.new
    end

    # GET /texts/1/edit
    def edit
    end

    # POST /texts
    def create
      @text = Text.new(text_params)

      if @text.save
        redirect_to @text, notice: 'Text was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /texts/1
    def update
      if @text.update(text_params)
        redirect_to @text, notice: 'Text was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /texts/1
    def destroy
      @text.destroy
      redirect_to texts_url, notice: 'Text was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_text
        @text = Text.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def text_params
        params.require(:text).permit(:content)
      end
  end
end
