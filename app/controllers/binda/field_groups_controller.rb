require_dependency "binda/application_controller"

module Binda
  class FieldGroupsController < ApplicationController
    before_action :set_structure
    before_action :set_field_group, only: [:show, :edit, :update, :destroy]

    # GET /field_groups
    def index
      @field_groups = @structure.field_groups.order('position').all
    end

    # GET /field_groups/1
    def show
      redirect_to action: :edit
    end

    # GET /field_groups/new
    def new
      @field_group = @structure.field_groups.build(  )
    end

    # GET /field_groups/1/edit
    def edit
    end

    # POST /field_groups
    def create
      @field_group = @structure.field_groups.build(field_group_params)

      if @field_group.save
        redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully created.'
      else
        redirect_to new_structure_field_group_path( @structure.slug ), flash: { alert: @field_group.errors }
      end
    end

    # PATCH/PUT /field_groups/1
    def update
      if @field_group.update(field_group_params)
        redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully updated.'
      else
        redirect_to edit_structure_field_group_path( @structure.slug, @field_group.slug ), flash: { alert: @field_group.errors }
      end
    end

    # DELETE /field_groups/1
    def destroy
      @field_group.destroy
      redirect_to structure_field_groups_url( @structure.slug ), notice: 'Field group was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_field_group
        @field_group = FieldGroup.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_group_params
        params.require(:field_group).permit(
          :name, 
          :slug, 
          :description, 
          :position, 
          :layout,
          :structure_id,
          field_settings_attributes: [
            :id, 
            :field_group_id, 
            :name, 
            :description,
            :field_type,
            :position,
            :required,
            :default_text
            ])
      end
  end
end
