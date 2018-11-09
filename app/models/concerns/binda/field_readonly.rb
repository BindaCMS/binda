module Binda
  module FieldReadonly
  
    extend ActiveSupport::Concern

    included do
      validate :is_read_only
    end

    def is_read_only
			errors.add(:base, I18n.t("binda.readonly_validation", { 
				arg1: self.class.name,
				arg2: self.field_setting.name, 
        arg3: self.id
			})) if self.field_setting.read_only?
    end

  end
end