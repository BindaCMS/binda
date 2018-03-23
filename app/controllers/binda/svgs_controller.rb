require_dependency "binda/application_controller"

module Binda
  class SvgsController < ApplicationController
    before_action :set_svg, only: [:show, :edit, :update, :destroy, :remove_svg]

    # GET /svgs
    def index
      @svgs = Svg.all
    end

    # GET /svgs/1
    def show
    end

    # GET /svgs/new
    def new
      @svg = Svg.new
    end

    # GET /svgs/1/edit
    def edit
    end

    # POST /svgs
    def create
      @svg = Svg.new(svg_params)

      if @svg.save
        redirect_to svg_path( @svg.id ), notice: 'Svg was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /svgs/1
    def update
      if @svg.update(svg_params)
        redirect_to svg_path( @svg.id ), notice: 'Svg was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /svgs/1
    def destroy
      @svg.destroy
      redirect_to svgs_url, notice: 'Svg was successfully destroyed.'
    end

    def remove_svg
      @svg.remove_svg!
      if @svg.save
        head :ok
      else
        render json: @svg.errors.full_messages, status: 400
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_svg
        @svg = Svg.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def svg_params
        params.require(:svg).permit( :svg, :name )
      end
  end
end
