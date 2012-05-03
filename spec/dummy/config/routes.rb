Rails.application.routes.draw do

  mount DynamicCopy::Engine => "/dynamic_copy"
end
