require_dependency "binda/application_controller"

module Binda
  class FieldGroupsController < ApplicationController
    before_action :set_structure
    before_action :set_field_group, only: [:show, :edit, :update, :destroy, :add_field_setting]

    def index
      redirect_to structure_field_group_path( @structure.slug )
    end

    def show
      redirect_to action: :edit
    end

    def new
      @field_group = @structure.field_groups.build()
    end

    def edit
    end

    def create
      @field_group = @structure.field_groups.build(field_group_params)

      if @field_group.save
        reset_field_settings_cache
        redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully created.'
      else
        redirect_to new_structure_field_group_path( @structure.slug ), flash: { alert: @field_group.errors }
      end
    end

    def update
      # Add nested classes
      add_new_choices
      check_if_needs_to_update_choices

      # Update the other ones
      if @field_group.update(field_group_params)
        reset_field_settings_cache
        redirect_to structure_field_group_path( @structure.slug, @field_group.slug ), notice: 'Field group was successfully updated.'
      else
        redirect_to edit_structure_field_group_path( @structure.slug, @field_group.slug ), flash: { alert: @field_group.errors }
      end
    end

    def destroy
      @field_group.destroy!
      reset_field_settings_cache
      if params[:isAjax]
        render json: { target_id: params[:target_id] }, status: 200
      else
        redirect_to structure_path( @structure.slug ), notice: 'Field group was successfully destroyed along with all dependents.'
      end
    end

    def sort
      params[:field_group].each_with_index do |id, i|
        FieldGroup.find( id ).update_column('position', i ) # use update_column to skip callbacks (which leads to huge useless memory consumption)
      end
      render json: { id: "##{params[:id]}" }, status: 200
    end

    def sort_field_settings
      params["form--list-item"].each_with_index do |id, i|
        FieldSetting.find( id ).update_column('position', i ) # use update_column to skip callbacks (which leads to huge useless memory consumption)
      end
      render json: { id: "##{params[:id]}" }, status: 200
    end

    def add_field_setting
      # We set some default values in order to be able to save the field setting
      # (if field setting isn't save it makes impossible to sort the order)
      @field_setting = FieldSetting.new(
        name: "#{I18n.t('binda.field_setting.new')}",
        field_group_id: @field_group.id, 
        field_type: 'string'
      )
      @field_setting[:ancestry] = params[:ancestry]
      @field_setting.save!
      # Put new repeater to first position, then store all the other ones
      if params["form--list-item"].nil?
        field_settings = [
          @field_setting.id.to_s, 
          *@field_group
            .field_settings
            .order('position ASC')
            .select{|fs| fs.ancestry == @field_setting.ancestry }
            .map(&:id)
        ]
      else
        field_settings = [
          @field_setting.id.to_s,
          *params["form--list-item"]
        ]
      end
      sort_field_setting_by(field_settings)
      render 'binda/field_groups/_form_new_item', layout: false
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
        params.require(:field_group).permit(:name, :slug, :description, :position, :layout, :structure_id, field_settings_attributes: [ :id, :field_group_id, :field_setting_id, :name, :slug, :description, :field_type, :position, :required, :default_text, :ancestry, :default_choice_id, :allow_null, accepted_structure_ids: [], choices: [], choices_attributes: [ :id, :field_setting_id, :label, :value ]])
      end

      def new_params
        params.require(:field_group).permit( new_field_settings: [ :id, :field_group_id, :field_setting_id, :name, :slug, :description, :field_type, :position, :required, :ancestry, :default_choice_id, :allow_null, choices: [] ],new_choices: [ :id, :field_setting_id, :label, :value ])
      end

      def reset_field_settings_cache
        FieldSetting.reset_field_settings_array
      end

      def add_new_choices
        # Create new fields if any
        return if new_params[:new_choices].nil? 
        new_params[:new_choices].each do |choice|
          next if choice[:label].blank? || choice[:value].blank?
          create_new_choice choice
        end
      end

      # Create new choice (depends directly from add_new_choice method)
      def create_new_choice choice
        new_choice = Choice.create( choice )
        unless new_choice
          return redirect_to edit_structure_field_group_path( @structure.slug, @field_group.slug ), flash: { error: new_choice.errors }
        end
      end

      def check_if_needs_to_update_choices
        return if field_group_params[:field_settings_attributes].nil?
        field_group_params[:field_settings_attributes].each do |_, field_setting_params|
          next if field_setting_params[:choices_attributes].nil?
          update_field_setting_choices field_setting_params
        end
      end

      def update_field_setting_choices field_setting_params
        field_setting_params[:choices_attributes].each do |_, choice_params|
          choice = Choice.find(choice_params[:id])
          unless choice.update(choice_params)
            return redirect_to edit_structure_field_group_path( @structure.slug, @field_group.slug ), flash: { error: choice.errors }
          end
        end
      end

      # Sort field settings following the order with which are listed in the array provided as a argument.
      #
      # @param field_settings [Array] the list of ids of the field settings
      def sort_field_setting_by(field_settings)
        field_settings.each_with_index do |id, i|
          FieldSetting.find( id ).update!({ position: i })
        end
      end
  end
end
