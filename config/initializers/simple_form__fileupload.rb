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
          elsif options[:object].audio.present?
            html << " fileupload--preview--uploaded fileupload--preview--hidden"
          end
          
          # Add no-preview text
          html << "\"><p>#{ t('binda.no_preview')}</p>"
        
          # Add video tag
          if options[:object].video.present?
            html << "<video id=\"video-#{options[:object].id}\" class=\"form-item--video--video\">"
            html << "<source src=\"#{options[:object].video.url}\" type=\"#{options[:object].video.content_type}\"></video>"
            html << "<audio class=\"form-item--audio--audio\"><source></audio>"
          elsif options[:object].audio.present?
            html << "<audio id=\"audio-#{options[:object].id}\" class=\"from-item--audio--audio\">"
            html << "<source src=\"#{options[:object].audio.url}\" type=\"#{options[:object].audio.content_type}\"></audio>"
            html << "<video class=\"form-item--video--video\"><source></video>"
          else
            html << "<video class=\"form-item--video--video\"><source></video>"
            html << "<audio class=\"form-item--audio--audio\"><source></audio>"
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
            html << ' fileupload--remove-image-btn--hidden' unless obj.image.present? || obj.video.present? || obj.audio.present?
            html << '" href="'
            html << url
            html << '" data-method="delete" data-remote="true" data-confirm="'
            html << t('binda.confirm_delete')
            html << '" data-id="'
            html << obj.id.to_s
            html << '">'
              html << '<i class="fa fa-trash-alt" aria-hidden="true"></i>'
              html << t('binda.delete')
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

          html = '<div class="fileupload--details'
          html << ' fileupload--details--hidden' unless obj.image.present? || obj.video.present? || obj.audio.present?
          html << '"><p class="fileupload--name">'
          html << "<strong>#{t 'binda.filename'}:</strong> "
          html << '<span class="fileupload--filename">'
          html << File.basename(obj.image.path).to_s if obj.image.present?
          html << File.basename(obj.video.path).to_s if obj.video.present?
          html << File.basename(obj.audio.path).to_s if obj.audio.present?
          html << '</span></p>'
          html << '<p class="fileupload--size">'
          html << "<strong>#{t 'binda.filesize'}:</strong> "
          html << '<span class="fileupload--filesize">'
          html << bytes_to_megabytes(obj.file_size).to_s unless obj.file_size.blank?
          html << 'MB</span></p>'
          html << '<p class="fileupload--dimension">'
          html << "<strong>#{t 'binda.filedimension'}:</strong> "
          html << '<span class="fileupload--width">'
          html << obj.file_width.round.to_s unless obj.file_width.blank?
          html << '</span> x <span class="fileupload--height">'
          html << obj.file_height.round.to_s unless obj.file_height.blank?
          html << '</span> px</p>'
          html << '<p class="fileupload--previewlink"><a href="'
          html << obj.video.url if obj.video.present?
          html << obj.audio.url if obj.audio.present?
          html << '" target="_blank"><i class="fas fa-external-link-alt"></i> <strong>'
          html << t('binda.filevideolink') if obj.video.present?
          html << t('binda.fileaudiolink') if obj.audio.present?
          html << '</strong></a></p>'

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