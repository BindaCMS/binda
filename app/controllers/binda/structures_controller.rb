require_dependency "binda/application_controller"

module Binda
  class StructuresController < ApplicationController
    before_action :set_structure, only: [:show, :edit, :update, :destroy]

    # GET /structures
    def index
      @structures = Structure.all
    end

    # GET /structures/1
    def show
      redirect_to action: :edit
    end

    # GET /structures/new
    def new
      @structure = Structure.new
    end

    # GET /structures/1/edit
    def edit
    end

    # POST /structures
    def create
      @structure = Structure.new(structure_params)

      if @structure.save
        redirect_to @structure.merge(:only_path => true), notice: 'Structure was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /structures/1
    def update
      if @structure.update(structure_params)
        redirect_to @structure.merge(:only_path => true), notice: 'Structure was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /structures/1
    def destroy
      @structure.destroy
      redirect_to structures_url, notice: 'Structure was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def structure_params
        params.require(:structure).permit(:name, :slug)
      end
  end
end
