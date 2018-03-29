require_dependency "binda/application_controller"

module Binda
  class StructuresController < ApplicationController
    before_action :set_structure, only: [:show, :edit, :update, :destroy, :fields_update, :add_field_group ]

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
        Structure.find( id ).update({ position: i })
      end
      render js: "$('##{params[:id]}').sortable('option', 'disabled', false); $('.popup-warning').addClass('popup-warning--hidden'); $('.sortable').removeClass('sortable--disabled')"
    end

    def sort_index
      @structures = Structure.order('position').all.page params[:page]
    end

    def sort_field_groups
      sort_field_group_by(params["form--list-item"])
      render json: { id: "##{params[:id]}" }, status: 200
    end

    def add_field_group
      # We set some default values in order to be able to save the field setting
      # (if field setting isn't save it makes impossible to sort the order)
      @field_group = FieldGroup.new(
        name: "#{I18n.t('binda.field_group.new')}",
        structure_id: @structure.id
      )
      @field_group.save!
      render 'binda/structures/_form_new_field_group_item', layout: false
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def structure_params
        params.require(:structure).permit(
          :name, :slug, :position, :has_categories, :has_preview, :instance_type, field_groups_attributes: [ 
            :id, :name, :structure_id, :slug, :description, field_settings_attributes: [
              :id, :name, :slug, :field_group_id
            ]
          ]
        )
      end

      def new_params
        params.require(:structure).permit( new_field_groups:[ :name, :slug, :structure_id ] )
      end

      # Sort field settings following the order with which are listed in the array provided as a argument.
      #
      # @param field_groups [Array] the list of ids of the field groups
      def sort_field_group_by(field_groups)
        field_groups.each_with_index do |id, i|
          FieldGroup.find( id ).update_column('position', i+1)
        end
      end

  end
end
