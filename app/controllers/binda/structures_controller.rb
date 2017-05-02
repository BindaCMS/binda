require_dependency "binda/application_controller"

module Binda
  class StructuresController < ApplicationController
    before_action :set_structure, only: [:show, :edit, :update, :destroy]

    def index
      @structures = Structure.all
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
        # Creates a default empty field group 
        @fiedl_group = @structure.field_groups.build( name: 'General Details' )
        unless @fiedl_group.save
          return redirect_to structure_path( @structure.slug ), flash: { error: 'General Details group hasn\'t been created' }
        end
        redirect_to structure_path( @structure.slug ), notice: 'Structure was successfully created.'
      else
        render :new
      end
    end

    def update
      # Create new fields if any
      new_params[:new_field_groups].each do |field_group|
        unless field_group[:name].blank?
          new_field_group = @structure.field_groups.create( name: field_group[:name] )
          unless new_field_group
            return redirect_to structure_path( @structure.slug ), flash: { error: new_field_group.errors }
          end
        end
      end
      # Update the other ones
      if @structure.update(structure_params)
        redirect_to structure_path( @structure.slug ), notice: 'Structure was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @structure.destroy
      redirect_to structures_url, notice: 'Structure was successfully destroyed.'
    end

    def fields_update
      redirect_to :back, notice: 'Page was successfully updated.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def structure_params
        params.require(:structure).permit(:name, :slug, field_groups_attributes: [ :id, :name, :structure_id, :slug ] )
      end

      def new_params
        params.require(:structure).permit( new_field_groups:[ :name, :structure_id ] )
      end
  end
end
