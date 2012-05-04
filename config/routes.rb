DynamicCopy::Engine.routes.draw do
  resources :translations, :only => [:index, :edit, :update], :constraints => { :id => /[^\/]+/ }
  resources :locales, :except => [:show], :constraints => { :id => /[^\/]+/ }

  get 'show_translation_link/:setting' => "show_translation_link#edit", :as => :show_translation_link
  root :to => "translations#index"
end
