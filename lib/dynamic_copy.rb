require "dynamic_copy/engine"
require "dynamic_copy/i18n_backend"

module DynamicCopy

  DATABASES = {
    "development" => 0,
    "test" => 1,
    "production" => 2
  }

  ## CONFIGURATION OPTIONS
  # http_basic_auth config
  mattr_accessor :username
  mattr_accessor :password

  # redis server configuration options
  mattr_reader :redis_options
  @@redis_options = { :db => DATABASES[Rails.env.to_s] }

  # merge with the default :db option
  def self.redis_options=(options = {})
    @@redis_options = { :db => DATABASES[Rails.env.to_s] }.merge(options)
  end

  # Default way to setup DynamicCopy
  # currently only http_basic_auth username and password is supported
  def self.setup
    yield self
  end

  def self.database
    @database ||= Redis.new(redis_options)
  end

  def self.convert_to_hash(key, value)
    key.split(".").reverse.inject(value) do |data, x|
      { x => data }
    end
  end

  def self.available_deepest_keys(locale)
    keys = database.keys("#{locale}.*")
    keys = keys.delete_if do |key|
      value = database[key]
      value && (ActiveSupport::JSON.decode(value).is_a?(Hash) rescue nil)
    end
    keys.map { |x| x.split('.')[1..-1].join('.') }
  end

  def self.available_keys
    locales.inject([]) { |keys, locale| keys += available_deepest_keys(locale) }.uniq
  end

  def self.locale_value(locale, key)
    database["#{locale}.#{key}"]
  end

  def self.reload!
    database.flushdb
    I18n.backend.load_translations
  end

  def self.clear_db!
    database.flushdb
    @locales = nil
    @locale_names = nil
  end

  def self.locales
    @locales ||= if database['available_locales']
                  ActiveSupport::JSON.decode(database['available_locales'])
                else
                  default_locale = [I18n.default_locale.to_s]
                  database['available_locales'] = ActiveSupport::JSON.encode(default_locale)
                  default_locale
                end
  end

  def self.add_locale(locale, name=nil)
    locale = locale.to_s.strip
    unless locale.blank? || locales.include?(locale)
      locales << locale
      database['available_locales'] = ActiveSupport::JSON.encode(locales)
    end

    locale_names[locale] = name.blank? ? locale.to_s : name
    database['locale_names'] = ActiveSupport::JSON.encode(locale_names)
  end

  def self.locale_names
    @locale_names ||= if database['locale_names']
                      ActiveSupport::JSON.decode(database['locale_names'])
                    else
                      default = { 'en' => 'English' }
                      locales.each { |x| default.reverse_merge!(x => x) }
                      database['locale_names'] = ActiveSupport::JSON.encode(default)
                      default
                    end
  end

  def self.delete_locale(locale)
    locale = locale.strip
    remove_from_available_locales(locale)
    remove_from_locale_names(locale)
    database.del *database.keys("#{locale}.*") unless database.keys("#{locale}.*").blank?
  end

  def self.remove_from_available_locales(locale)
    locales.delete(locale)
    if locales.blank?
      @locales = nil
      database.del('available_locales')
    else
      database['available_locales'] = ActiveSupport::JSON.encode(locales)
    end
  end

  def self.remove_from_locale_names(locale)
    locale_names.delete(locale)
    if locale_names.blank?
      @locale_names = nil
      database.del('locale_names')
    else
      database['locale_names'] = ActiveSupport::JSON.encode(locale_names)
    end
  end

end