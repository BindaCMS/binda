require_dependency "binda/application_controller"

module Binda
  class FieldGroupsController < ApplicationController
    before_action :set_field_group, only: [:show, :edit, :update, :destroy]

    # GET /field_groups
    def index
      @field_groups = FieldGroup.all
    end

    # GET /field_groups/1
    def show
      redirect_to action: :edit
    end

    # GET /field_groups/new
    def new
      @field_group = FieldGroup.new
    end

    # GET /field_groups/1/edit
    def edit
    end

    # POST /field_groups
    def create
      @field_group = FieldGroup.new(field_group_params)

      if @field_group.save
        redirect_to @field_group, only_path: true, notice: 'Field group was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /field_groups/1
    def update
      if @field_group.update(field_group_params)
        redirect_to @field_group, only_path: true, notice: 'Field group was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /field_groups/1
    def destroy
      @field_group.destroy
      redirect_to field_groups_url, notice: 'Field group was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_field_group
        @field_group = FieldGroup.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_group_params
        params.require(:field_group).permit(:name, :slug, :description, :position, :layout)
      end
  end
end
