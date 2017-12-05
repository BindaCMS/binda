module SimpleForm
  module Components

    # Needs to be enabled in order to do automatic lookups
    module Previews
      
      # Name of the component method
      def preview(wrapper_options = nil)
        @preview ||= begin
          # open a div tag for the file preview
          html = '<div class="fileupload--preview' 
          # add preview image if it's set
          html << " fileupload--preview--uploaded\" style=\"background-image: url(#{options[:object].image.url})" if options[:object].image.present?
          # close div tag
          html << "\"><p>#{ t('binda.no_preview')}</p></div>"
        end
      end

      # Used when the preview is optional
      def has_preview?
        preview.present?
      end

    end

    module DeleteButtons
      def delete_button(wrapper_options = nil)
        @delete_button ||= begin
          obj = options[:object]
          url = options[:url]
          html = '<a class="b-btn b-btn-outline-danger fileupload--remove-image-btn'
            html << ' fileupload--remove-image-btn--hidden' unless obj.image.present?
            html << '" href="'
            html << url
            html << '" data-method="delete" data-remote="true" data-confirm="'
            html << t('binda.confirm_delete')
            html << '" data-id="'
            html << obj.id.to_s
            html << '">'
              html << '<i class="fa fa-trash-o" aria-hidden="true"></i> Delete image'
          html << '</a>'
          html << '<div class="clearfix"></div>'
        end
      end

      # Used when the preview is optional
      def has_delete_button?
        delete_button.present?
      end
    end

    module Details
      def detail(wrapper_options = nil)
        @detail ||= begin
          obj = options[:object]

          if obj.image.present?
            if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::File
              image = MiniMagick::Image.open(::Rails.root.join(obj.image.path))
            else
              image = MiniMagick::Image.open(obj.image.url)
            end
          end

          html = '<div class="fileupload--details'
          html << ' fileupload--details--hidden' unless obj.image.present?
          html << '"><p class="fileupload--name">'
          html << "<strong>#{t 'binda.filename'}:</strong> "
          html << "<span class=\"fileupload--filename\">"
          html << File.basename(obj.image.path).to_s if obj.image.present?
          html << "</span></p>"
          html << '<p class="fileupload--size">'
          html << "<strong>#{t 'binda.filesize'}:</strong> "
          html << "<span class=\"fileupload--width\">"
          html << image[:width].to_s unless image.nil?
          html << "</span> x <span class=\"fileupload--height\">"
          html << image[:height].to_s unless image.nil?
          html << "</span> px</p>"
          html << '</div>'
        end
      end

      # Used when the preview is optional
      def has_detail?
        detail.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Previews)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::DeleteButtons)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Details)