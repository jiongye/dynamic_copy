module DynamicCopy
  class Engine < ::Rails::Engine
    isolate_namespace DynamicCopy

    initializer 'dynamic_copy.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper DynamicCopy::ApplicationHelper
      end
    end

  end
end
