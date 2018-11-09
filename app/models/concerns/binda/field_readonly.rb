module Binda
  module FieldReadonly
  
    extend ActiveSupport::Concern

    included do
      validate :is_read_only
    end

    def is_read_only
      field_setting = self.field_setting
      if field_setting.read_only?
        # check if content is changed
        # load previous db instance
        db_instance = "Binda::#{field_setting.field_type.classify}".constantize.find_by(
          fieldable_id: self.fieldable_id, fieldable_type: self.fieldable_type, field_setting_id: field_setting.id )
        
        # check if active record instance you want to save is different        
        # generate an error if it is
        # else do nothing
        if self.persisted? && db_instance.attributes != self.attributes
          errors.add(:base, I18n.t("binda.readonly_validation", { 
            arg1: self.class.name,
            arg2: self.field_setting.name, 
            arg3: self.id
          }))
        end
      end
    end

  end
end