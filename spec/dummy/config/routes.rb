Rails.application.routes.draw do

  get "home/index"

  mount DynamicCopy::Engine => "/dynamic_copy", :as => :dynamic_copy

  root :to => 'home#index'
end
