require_dependency "binda/application_controller"

module Binda
  class BindingsController < ApplicationController
    before_action :set_binding, only: [:show, :edit, :update, :destroy]

    # GET /bindings
    def index
      @bindings = Binding.all
    end

    # GET /bindings/1
    def show
    end

    # GET /bindings/new
    def new
      @binding = Binding.new
    end

    # GET /bindings/1/edit
    def edit
    end

    # POST /bindings
    def create
      @binding = Binding.new(binding_params)

      if @binding.save
        redirect_to @binding, notice: 'Binding was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /bindings/1
    def update
      if @binding.update(binding_params)
        redirect_to @binding, notice: 'Binding was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /bindings/1
    def destroy
      @binding.destroy
      redirect_to bindings_url, notice: 'Binding was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_binding
        @binding = Binding.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def binding_params
        params.require(:binding).permit(:title, :description, :position)
      end
  end
end
