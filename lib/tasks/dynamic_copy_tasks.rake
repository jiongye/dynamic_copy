namespace :dynamic_copy do

  desc 'Load exist locales from all yml files into the key value store, this should only run when setup the Dynamic Copy store'
  task :load_translations => :environment do
    I18n.backend.load_translations
    DynamicCopy.database.bgsave
  end

  desc 'Load a single yml file from the given path'
  task :load_locale_file => :environment do
    if ENV['file_path'].blank?
      puts "INFO: Please use 'rake dynamic_copy:load_locale_file file_path=path/to/your/file' to run the rake task"
    else
      data = YAML.load_file(ENV['file_path'])
      raise "There is invalid locale data from the file you provided" unless data.is_a?(Hash)
      data.each { |locale, d| I18n.backend.store_translations(locale, d || {}) }
      DynamicCopy.database.bgsave
    end
  end

  desc 'Reload all the locales from yml files into the key value store, this will destroy all the exist data in the key value store'
  task :reload_translations => :environment do
    DynamicCopy.reload!
    DynamicCopy.database.bgsave
  end

  desc 'Generate config file'
  task :generate_config_file do
    username = (0...8).map{ ('a'..'z').to_a[rand(26)] }.join
    password = (0...8).map{ ('a'..'z').to_a[rand(26)] }.join
    filepath = Rails.root.join('config', 'initializers', 'dynamic_copy.rb')
    File.open(filepath, 'w') do |f|
      f << <<-CONFIG
DynamicCopy.setup do |config|
  config.username = '#{username}'
  config.password = '#{password}'
end
CONFIG
    end
  end

end