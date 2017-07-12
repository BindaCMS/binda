require_dependency "binda/application_controller"

module Binda
  class ComponentsController < ApplicationController
    before_action :set_structure
    before_action :set_component, only: [:show, :edit, :update, :destroy, :new_repeater]
    before_action :set_position, only: [:create]

    def index
      @components = @structure.components.order('position').all
    end

    def show
      redirect_to action: :edit
    end

    def new
      @component = @structure.components.build()
    end

    def edit
    end

    def create
      @component = @structure.components.build(component_params)
      @component.position = @position
      if @component.save
        redirect_to structure_component_path( @structure.slug, @component.slug ), notice: 'Component was successfully created.'
      else
        redirect_to new_structure_component_path( @structure.slug ), flash: { alert: @component.errors }
      end
    end

    def update
      if @component.update(component_params)
        redirect_to structure_component_path( @structure.slug, @component.slug ), notice: 'Component was successfully updated.'
      else
        redirect_to edit_structure_component_path( @structure.slug, @component.slug ), flash: { alert: @component.errors }
      end
    end

    def destroy
      @component.destroy
      redirect_to structure_components_url( @structure.slug ), notice: 'Component was successfully destroyed.'
    end

    def new_repeater
      @repeater_setting = Binda::FieldSetting.find( params[:repeater_setting_id] )
      position = @component.repeaters.find_all{|r| r.field_setting_id=@repeater_setting.id }.length + 1
      @repeater = @component.repeaters.create( field_setting: @repeater_setting, position: position )
      render 'binda/components/_form_item_new_repeater', layout: false
    end

    def sort_repeaters
      params[:repeater].each_with_index do |id, i|
        Binda::Repeater.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    def sort
      params[:component].each_with_index do |id, i|
        Binda::Component.find( id ).update({ position: i + 1 })
      end
      head :ok
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_structure
        @structure = Structure.friendly.find( params[:structure_id] )
      end

      def set_component
        if params[:component_id].nil?
          return @component = Component.friendly.find(params[:id])
        else
          return @component = Component.friendly.find(params[:component_id])
        end
      end

      # Only allow a trusted parameter "white list" through.
      def component_params
        params.require(:component).permit( 
          :name, 
          :slug, 
          :position, 
          :publish_state, 
          :structure_id, 
          :category_ids,
          structure_attributes: [ 
            :id
            ], 
          categories_attributes: [ 
            :id,
            :category_id
            ], 
          texts_attributes: [ 
            :id, 
            :field_setting_id, 
            :fieldable_type,
            :fieldable_id,
            :content
            ], 
          assets_attributes: [ 
            :id,
            :field_setting_id,
            :fieldable_type,
            :fieldable_id,
            :image
            ], 
          dates_attributes: [ 
            :id,
            :field_setting_id,
            :fieldable_type,
            :fieldable_id,
            :date
            ], 
          galleries_attributes: [ 
            :id,
            :field_setting_id,
            :fieldable_type,
            :fieldable_id
            ], 
          repeaters_attributes: [ 
            :id, 
            :field_setting_id, 
            :field_group_id,
            :fieldable_type,
            :fieldable_id,
            texts_attributes: [ 
              :id, 
              :repeater_id,
              :field_setting_id, 
              :fieldable_type,
              :fieldable_id,
              :content
              ], 
            assets_attributes: [ 
              :id,
              :repeater_id,
              :field_setting_id,
              :fieldable_type,
              :fieldable_id,
              :image
              ], 
            dates_attributes: [ 
              :id,
              :repeater_id,
              :field_setting_id,
              :fieldable_type,
              :fieldable_id,
              :date
              ], 
            galleries_attributes: [ 
              :id,
              :repeater_id,
              :field_setting_id,
              :fieldable_type,
              :fieldable_id
              ], 
            repeaters_attributes: [ 
              :id, 
              :repeater_id,
              :field_setting_id, 
              :field_group_id,
              :fieldable_type,
              :fieldable_id
              ]
            ])
      end

      def repeater_params
        params.require(:repeater).permit( 
          new_repeaters_attributes: [ 
            :id, 
            :field_setting_id, 
            :field_group_id,
            :fieldable_type,
            :fieldable_id,
            texts_attributes: [ 
              :id, 
              :field_setting_id, 
              :fieldable_type,
              :fieldable_id,
              :content
              ], 
            assets_attributes: [ 
              :id,
              :field_setting_id,
              :fieldable_type,
              :fieldable_id,
              :image
              ], 
            dates_attributes: [ 
              :id,
              :field_setting_id,
              :fieldable_type,
              :fieldable_id,
              :date
              ], 
            galleries_attributes: [ 
              :id,
              :field_setting_id,
              :fieldable_type,
              :fieldable_id
              ], 
            repeaters_attributes: [ 
              :id, 
              :field_setting_id, 
              :field_group_id,
              :fieldable_type,
              :fieldable_id
              ]
            ])
      end

      def set_position
        @position = @structure.components.order(:position).pluck(:position).last.to_i + 1 unless @position.to_i > 0
      end

  end
end

