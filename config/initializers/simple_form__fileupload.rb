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
          if options[:object].image.present?
            html << " fileupload--preview--uploaded\" style=\"background-image: url(#{options[:object].image.url})" 
          elsif options[:object].video.present?
            html << " fileupload--preview--uploaded" 
          end
          
          # Add no-preview text
          html << "\"><p>#{ t('binda.no_preview')}</p>"
        
          # Add video tag
          if options[:object].video.present?
            html << "<video id=\"video-#{options[:object].id}\" class=\"form-item--video--video\">"
            html << "<source src=\"#{options[:object].video.url}\" type=\"video/#{options[:object].video.file.extension.downcase}\"></video>"
          else
            html << "<video class=\"form-item--video--video\"><source></video>"
          end
          
          # Close preview container
          html << "</div>"
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
            html << ' fileupload--remove-image-btn--hidden' unless obj.image.present? || obj.video.present?
            html << '" href="'
            html << url
            html << '" data-method="delete" data-remote="true" data-confirm="'
            html << t('binda.confirm_delete')
            html << '" data-id="'
            html << obj.id.to_s
            html << '">'
              html << '<i class="fa fa-trash-alt" aria-hidden="true"></i> Delete image'
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
          html << ' fileupload--details--hidden' unless obj.image.present? || obj.video.present?
          html << '"><p class="fileupload--name">'
          html << "<strong>#{t 'binda.filename'}:</strong> "
          html << '<span class="fileupload--filename">'
          html << File.basename(obj.image.path).to_s if obj.image.present?
          html << File.basename(obj.video.path).to_s if obj.video.present?
          html << '</span></p>'
          html << '<p class="fileupload--size">'
          html << "<strong>#{t 'binda.filesize'}:</strong> "
          html << '<span class="fileupload--filesize">'
          html << bytes_to_megabytes(obj.image.size).to_s if obj.image.present?
          html << bytes_to_megabytes(obj.video.size).to_s if obj.video.present?
          html << 'MB</span></p>'
          html << '<p class="fileupload--dimension">'
          html << "<strong>#{t 'binda.filedimension'}:</strong> "
          html << '<span class="fileupload--width">'
          html << image[:width].to_s unless image.nil?
          html << '</span> x <span class="fileupload--height">'
          html << image[:height].to_s unless image.nil?
          html << '</span> px</p>'
          html << '</div>'
        end
      end

      # Used when the preview is optional
      def has_detail?
        detail.present?
      end

      def bytes_to_megabytes bytes
        (bytes.to_f / 1.megabyte).round(2)
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Previews)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::DeleteButtons)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Details)