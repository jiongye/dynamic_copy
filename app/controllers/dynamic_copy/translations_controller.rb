module DynamicCopy

  class TranslationsController < ApplicationController
    http_basic_authenticate_with :name => DynamicCopy.username, :password => DynamicCopy.password

    before_filter :get_locale
    before_filter :available_locales, :only => [:index, :edit]

    def index
      @keys = DynamicCopy.available_keys.sort
    end

    def edit
      session[:return_to] = request.referer
      @key = params[:id]
      render :partial => 'edit'
    end

    def update
      @key = params[:id]
      params[:locales].each do |locale, data|
        next if data.values[0].blank?
        I18n.backend.store_translations(locale, data, :escape => false)
      end

      DynamicCopy.database.bgsave
      flash[:notice] = "Translation for key '#{@key}' has been updated"
      redirect_to session[:return_to] || translations_path(:locale => @locale)
    end

    protected

    def available_locales
      @locales = DynamicCopy.locales
    end

    def get_locale
      @locale = params[:locale] || I18n.default_locale.to_s
    end

  end

end