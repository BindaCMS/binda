module Binda
  module FieldableHelpers
    
    extend ActiveSupport::Concern

      # Only allow a trusted parameter "white list" through.
      def fieldable_params 
        [ texts_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
          assets_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image ], 
          dates_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
          galleries_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id ],
          radios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
          selects_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
          checkboxes_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ],
          repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id,
            texts_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
            assets_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image ], 
            dates_attributes:      [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
            galleries_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id ], 
            repeaters_attributes:  [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :field_group_id ],
            radios_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
            selects_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
            checkboxes_attributes: [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ]
          ]]
      end

      def repeater_params
        params.require(:repeater).permit( 
          new_repeaters_attributes: [ :id, :field_setting_id, :field_group_id, :fieldable_type, :fieldable_id,
            texts_attributes:         [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :content ], 
            assets_attributes:        [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :image ], 
            dates_attributes:         [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :date ], 
            galleries_attributes:     [ :id, :field_setting_id, :fieldable_type, :fieldable_id ], 
            repeaters_attributes:     [ :id, :field_setting_id, :field_group_id, :fieldable_type, :fieldable_id ],
            radios_attributes:        [ :id, :field_setting_id, :fieldable_type, :fieldable_id, :choice_ids ],
            selects_attributes:       [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ],
            checkboxes_attributes:    [ :id, :field_setting_id, :fieldable_type, :fieldable_id, choice_ids: [] ]
          ])
      end

  end
end