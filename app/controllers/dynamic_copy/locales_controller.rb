module DynamicCopy

  # TODO: create a locale model to abstract the locale related stuff
  class LocalesController < ApplicationController
    http_basic_authenticate_with :name => DynamicCopy.username, :password => DynamicCopy.password

    def index
      @locales = DynamicCopy.locales
    end

    def new
    end

    def create
      if params[:locale_code].blank?
        flash.now[:alert] = "Locale code is required"
        @locale_name = params[:locale_name]
        render 'new'
      else
        DynamicCopy.add_locale(params[:locale_code], params[:locale_name])
        DynamicCopy.database.save
        redirect_to locales_path, :notice => "New Locale has been added successfully"
      end
    end

    def edit
      @locale_code = params[:id]
      @locale_name = DynamicCopy.locale_names[@locale_code]
    end

    def update
      if params[:locale_code].blank?
        flash.now[:alert] = "Locale code is required"
        @locale_name = params[:locale_name]
        render 'edit'
      else
        DynamicCopy.add_locale(params[:locale_code], params[:locale_name])
        DynamicCopy.database.save
        redirect_to locales_path, :notice => "Locale has been updated successfully"
      end
    end

    def destroy
      locale = params[:id]
      DynamicCopy.delete_locale(locale)
      redirect_to locales_path, :notice => "All translations for locale #{locale} has been deleted."
    end

  end

end