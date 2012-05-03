module DynamicCopy
  module ApplicationHelper

    def t(*args)
      output = I18n.translate(*args)
      output << content_tag(:span, link_to('translate', edit_translation_path(:id => args.shift)))
      output
    end

  end
end
