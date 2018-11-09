# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  # Bootstrap Simple Form defaults
  config.error_notification_class = 'b-alert b-alert--danger'
  config.button_class = 'b-btn b-btn-default'
  config.boolean_label_class = nil


  config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'col-sm-offset-3 col-sm-9' do |wr|
      wr.wrapper tag: 'div', class: 'checkbox' do |ba|
        ba.use :label_input
      end

      wr.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      wr.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-sm-3 control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end


  # Binda custom settings
  # ---------------------
  config.label_text = proc { |label, required| "#{label} #{required}" }

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'control-label', wrap_with: { tag: 'div', class: 'control-label-wrap' }

    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    b.use :input, class: 'form-control'
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'control-label', wrap_with: { tag: 'div', class: 'control-label-wrap' }

    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    b.use :input
  end

  config.wrappers :fileupload do |b|
    b.optional :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.wrapper tag: :p, class: 'help-block', unless_blank: true do |bb|
      bb.optional :hint
    end
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly

    b.use :preview 

    # ApplicationController.render(
    #   assigns: { builder: b },
    #   template: 'binda/fieldable/_form_item_upload_file',
    #   layout: false
    # )

    b.wrapper tag: 'div', class: 'fileupload--dashboard' do |bb|
      bb.use :label, class: 'control-label b-btn b-btn-primary', wrap_with: { tag: 'div', class: 'control-label-wrap' }
      bb.use :delete_button
      bb.use :detail
    end
    
    b.use :input
  end

  config.wrappers :file_read_only do |b|
    b.optional :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.wrapper tag: :p, class: 'help-block', unless_blank: true do |bb|
      bb.optional :hint
    end
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly

    b.use :preview 

    b.wrapper tag: 'div', class: 'fileupload--dashboard' do |bb|
      bb.use :delete_button
      bb.use :detail
    end
    
    b.use :input
  end

  config.wrappers :file_uploadable do |b|
    b.optional :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.wrapper tag: :p, class: 'help-block', unless_blank: true do |bb|
      bb.optional :hint
    end
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly

    b.use :preview 

    b.wrapper tag: 'div', class: 'fileupload--dashboard' do |bb|
      bb.use :label, class: 'control-label b-btn b-btn-primary', wrap_with: { tag: 'div', class: 'control-label-wrap test-label' }
      bb.use :delete_button
      bb.use :detail
    end
    
    b.use :input
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end
  end
  
  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'control-label', wrap_with: { tag: 'div', class: 'control-label-wrap' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    b.use :input
  end

  config.wrappers :multi_select, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'control-label', wrap_with: { tag: 'div', class: 'control-label-wrap' }
    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      ba.use :input, class: 'form-control', style: 'width: 120px'
    end
  end
  
  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :file_uploadable,
    boolean: :vertical_boolean,
    datetime: :multi_select,
    date: :multi_select,
    time: :multi_select
  }

end
