# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag.match?(/^\<label/)
    html_tag
  else
    class_attribute_index = html_tag.index 'class="'

    if class_attribute_index
      html_tag.insert class_attribute_index + 7, 'is-invalid '
    else
      html_tag.insert html_tag.index('>'), ' class="is-invalid"'
    end

    feedback = if instance.error_message.is_a?(Array)
                 instance.error_message.uniq.join(', ')
               else
                 instance.error_message
               end

    %(#{html_tag}<div class="invalid-feedback">#{feedback}</div>).html_safe
  end
end
