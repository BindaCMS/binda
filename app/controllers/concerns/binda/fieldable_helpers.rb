module Binda
  module FieldableHelpers
    
    extend ActiveSupport::Concern

    # Only allow a trusted parameter "white list" through.
    def fieldable_params 
      [ texts_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
        strings_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
        images_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ], 
        videos_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :video, :video_cache ], 
        audios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :audio, :audio_cache ], 
        dates_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
        galleries_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id ],
        radios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
        selections_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
        checkboxes_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ],
        relations_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, dependent_component_ids: [], dependent_board_ids: []  ],
        repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id,
          texts_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
          strings_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
          images_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ], 
          videos_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :video, :video_cache ], 
          audios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :audio, :audio_cache ], 
          dates_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
          galleries_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id ],
          relations_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, dependent_component_ids: [],  dependent_board_ids: []  ],
          repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id ],
          radios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
          selections_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
          checkboxes_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ]
        ]]
    end

    # Uploads parameters.
    # 
    # @param      fieldable_type {symbol} It can be `:component` or `:board`.
    #
    # @return     {hash} It returns a hash with the permitted upload parameters
    #
    def upload_params fieldable_type
      params.require(fieldable_type).permit( 
        :id, :name, :slug, :position, :publish_state, :structure_id, :category_ids,
        {structure_attributes:  [ :id ]}, 
        {categories_attributes: [ :id, :category_id ]}, 
        {images_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ]}, 
        {videos_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :video, :video_cache ]}, 
        {audios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :audio, :audio_cache ]},
        {repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id,
          images_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image, :image_cache ],
          videos_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :video, :video_cache ],
          audios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :audio, :audio_cache ]]})
    end

    # Uploads a details for a fieldable instance (component or board)
    #
    # @return     {hash} containig the array of images
    # 
    # @example    The return value will be something like: 
    #   # Return hash
    #   { 
    #     name: 'my_image.png',
    #     size: 543876,
    #     width: 300,
    #     height: 300,
    #     url: 'url/to/my_image.png',
    #     thumbnailUrl: 'url/to/my_image_thumb.png'
    #   }
    #
    def upload_details

      # Because this is a callback that happens right after the upload
      # chances are that it's also the latest asset that has been updated.
      # Therefore get the latest uploaded asset
      asset = Asset.order('updated_at').last

      if asset.image.present?
        return_image_details(asset)
      elsif asset.video.present?
        return_video_details(asset)
      elsif asset.audio.present?
        return_audio_details(asset)
      else
        raise "The record Binda::Asset with id=#{asset.id} doesn't have any image, video or audio attached. This might be due to a bug. Please report it in Binda official Github page."
      end
    end


    # Return image details
    # 
    # This helper is used internally by the `upload_details` method 
    #   to retrieve and return the necessary details to be displayed on
    #   the editor.
    def return_image_details asset
      # get image dimension
      if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::File
        file = MiniMagick::Image.open(::Rails.root.join(asset.image.path))
      else
        file = MiniMagick::Image.open(asset.image.url)
      end
      return { 
        type: 'image',
        name: asset.image_identifier,
        size: "#{bytes_to_megabytes( asset.image.size )}MB",
        width: file.width,
        height: file.height,
        url: asset.image.url,
        thumbnailUrl: asset.image.thumb.url 
      }
    end


    # Return video details
    # 
    # This helper is used internally by the `upload_details` method 
    #   to retrieve and return the necessary details to be displayed on
    #   the editor.
    def return_video_details asset
      return {
        type: 'video',
        name: asset.video_identifier,
        size: "#{bytes_to_megabytes( asset.video.size )}MB",
        url: asset.video.url,
        contentType: asset.content_type
      }
    end


    # Return audio details
    # 
    # This helper is used internally by the `upload_details` method 
    #   to retrieve and return the necessary details to be displayed on
    #   the editor.
    def return_audio_details asset
      return {
        type: 'audio',
        name: asset.audio_identifier,
        size: "#{bytes_to_megabytes( asset.audio.size )}MB",
        url: asset.audio.url,
        contentType: asset.content_type
      }
    end

    # Convert bytes to megabites
    def bytes_to_megabytes bytes
      (bytes.to_f / 1.megabyte).round(2)
    end
  end
end