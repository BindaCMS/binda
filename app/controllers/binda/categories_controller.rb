require_dependency "binda/application_controller"

module Binda
  class CategoriesController < ApplicationController
    before_action :set_structure
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = @structure.categories.order(:name).all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @category = @structure.categories.build()
    end

    def edit
    end

    def create
      @category = @structure.categories.build(category_params)
      if @category.save
        redirect_to structure_category_path( @structure.slug, @category.slug ), notice: 'Category was successfully created.'
      else
        redirect_to structure_category_path( @structure.slug, @category.slug )
      end
    end

    def update
      if @category.update(category_params)
        redirect_to structure_category_path( @structure.slug, @category.slug ), notice: 'Category was successfully updated.'
      else
        redirect_to structure_category_path( @structure.slug, @category.slug )
      end
    end

    def destroy
      @category.destroy
      redirect_to structure_categories_url( @structure.slug ), notice: 'Category was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_category
        @category = Category.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def category_params
        params.require(:category).permit(:name, :slug, :structure_id)
      end

      def set_structure
        @structure = Structure.friendly.find(params[:structure_id])
      end
  end
end
