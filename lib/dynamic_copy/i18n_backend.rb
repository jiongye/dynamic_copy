module DynamicCopy

  class I18nBackend < I18n::Backend::KeyValue

    def initialize(options = {})
      DynamicCopy.redis_options = options
      super(DynamicCopy.database)
    end

    # find the translation and also store the missing translate to the key-value store
    # also mark the return value as html_safe if the return value is a string
    def translate(locale, key, options = {})
      new_key = normalize_flat_keys(locale, key, options[:scope], options[:separator])
      content = super
      store_translations(locale, DynamicCopy.convert_to_hash(new_key, content), :escape => false) unless store["#{locale}.#{new_key}"]
      content.respond_to?(:html_safe) ? content.html_safe : content
    end

    # override the method that don't encode the value if it is a String
    # also remove any open and close <script></script> tags
    def store_translations(locale, data, options = {})
      escape = options.fetch(:escape, true)
      flatten_translations(locale, data, escape, @subtrees).each do |key, value|
        key = "#{locale}.#{key}"

        case value
        when Hash
          if @subtrees && (old_value = @store[key])
            old_value = ActiveSupport::JSON.decode(old_value)
            value = old_value.deep_symbolize_keys.deep_merge!(value) if old_value.is_a?(Hash)
          end
        when Proc
          raise "Key-value stores cannot handle procs"
        end

        unless value.is_a?(Symbol)
          if value.is_a?(String)
            @store[key] = value.strip.gsub(/\<script.*?\>|\<\/script\>/, '') unless value.blank? # don't store the locale if it is empty
          else
            @store[key] = ActiveSupport::JSON.encode(value)
          end
        end
      end
    end

    protected

    def lookup(locale, key, scope = [], options = {})
      key   = normalize_flat_keys(locale, key, scope, options[:separator])
      value = store["#{locale}.#{key}"]
      value = ActiveSupport::JSON.decode(value) rescue value
      value.is_a?(Hash) ? value.deep_symbolize_keys : value
    end
  end

end
