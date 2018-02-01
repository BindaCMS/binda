require_dependency "binda/application_controller"

module Binda
  class StructuresController < ApplicationController
    before_action :set_structure, only: [:show, :edit, :update, :destroy, :fields_update ]

    def index
      @structures = Structure.order('position').all.page params[:page]
    end

    def show
      redirect_to action: :edit
    end

    def new
      @structure = Structure.new
    end

    def edit
    end

    def create
      @structure = Structure.new(structure_params)

      if @structure.save
        redirect_to structure_path( @structure.slug ), notice: "#{ @structure.name.capitalize } structure was successfully created."
      else
        render :new
      end
    end

    def update
      # Create new fields if any
      add_new_field_groups

      # Update the other ones
      if @structure.update(structure_params)
        redirect_to structure_path( @structure.slug ), notice: "#{ @structure.name.capitalize } structure was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @structure.destroy
      redirect_to structures_url, notice: "#{ @structure.name.capitalize } structure was successfully destroyed."
    end

    def fields_update
      redirect_to :back, notice: "#{ @structure.name.capitalize } structure was successfully updated."
    end

    def sort
      params[:structure].each_with_index do |id, i|
        Structure.find( id ).update({ position: i + 1 })
      end
      render js: "$('##{params[:id]}').sortable('option', 'disabled', false); $('.popup-warning').addClass('popup-warning--hidden'); $('.sortable').removeClass('sortable--disabled')"
    end

    def sort_index
      @structures = Structure.order('position').all.page params[:page]
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def structure_params
        params.require(:structure).permit(:name, :slug, :position, :has_categories, :has_preview, :instance_type, field_groups_attributes: [ :id, :name, :structure_id, :slug ] )
      end

      def new_params
        params.require(:structure).permit( new_field_groups:[ :name, :slug, :structure_id ] )
      end

      def add_new_field_groups
        new_params[:new_field_groups].each do |field_group|
          next if field_group[:name].blank?
          new_field_group = @structure.field_groups.create(name: field_group[:name], slug: field_group[:slug])
          unless new_field_group
            return redirect_to(
              structure_path(@structure.slug), 
              flash: { error: new_field_group.errors }
            )
          end
        end
      end
  end
end
