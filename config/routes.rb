DynamicCopy::Engine.routes.draw do
  resources :translations, :only => [:index, :edit, :update], :constraints => { :id => /[^\/]+/ }
  resources :locales, :except => [:show], :constraints => { :id => /[^\/]+/ }

  root :to => "translations#index"
end
