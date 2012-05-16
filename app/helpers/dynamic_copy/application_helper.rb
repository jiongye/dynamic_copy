module DynamicCopy
  module ApplicationHelper

    def t(*args)
      output = I18n.translate(*args)
      output << content_tag(:span, link_to('translate', dynamic_copy.edit_translation_path(:id => args.shift), :class => 'edit_translation')) if session[:show_translation_link]
      output
    end

  end
end
