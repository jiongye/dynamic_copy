module DynamicCopy
  class ShowTranslationLinkController < ActionController::Base
    http_basic_authenticate_with :name => DynamicCopy.username, :password => DynamicCopy.password

    def edit
      session[:show_translation_link] = params[:setting] == 'yes' ? true : false

      redirect_to main_app.root_path, :notice => "The show translation links is now #{session[:show_translation_link] ? "enable" : "disable"}"
    end

  end
end