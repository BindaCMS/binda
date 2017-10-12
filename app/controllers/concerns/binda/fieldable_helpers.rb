module Binda
  module FieldableHelpers
    
    extend ActiveSupport::Concern

      # Only allow a trusted parameter "white list" through.
      def fieldable_params 
        [ texts_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
          strings_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
          assets_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ], 
          dates_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
          galleries_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id ],
          radios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
          selections_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
          checkboxes_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ],
          repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id,
            texts_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
            strings_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
            assets_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ], 
            dates_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
            galleries_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id ], 
            repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id ],
            radios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
            selections_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
            checkboxes_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ]
          ]]
      end

      #
      # @brief      Uploads parameters.
      # 
      # @param      fieldable_type {symbol} It can be `:component` or `:board`.
      #
      # @return     {hash} It returns a hash with the permitted upload parameters
      #
      def upload_params fieldable_type
        params.require(fieldable_type).permit( 
          :name, :slug, :position, :publish_state, :structure_id, :category_ids,
          {structure_attributes:  [ :id ]}, 
          {categories_attributes: [ :id, :category_id ]}, 
          {assets_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ]}, 
          {repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id,
            assets_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ]]})
      end

      #
      # @brief      Uploads a details for a fieldable instance (component or board)
      #
      # @param      fieldable_instance {symbol} can be a `:component` or `:board`
      # @return     {hash} containig the array of images
      # 
      # @example    The return value will be something like: 
      #   # Return hash
      #   { files: [
      #     name: 'my_image.png',
      #     size: 543876,
      #     url: 'url/to/my_image.png'
      #   ]}
      #
      def upload_details
        # get the latest uploaded image which should be the one the user just uploaded
        asset = Asset.order('updated_at').last
        return { files: [{ name: asset.image_identifier,
                    size: asset.image.size,
                    url: asset.image.url,
                    thumbnailUrl: asset.image.thumb.url }] }
      end


  end
end