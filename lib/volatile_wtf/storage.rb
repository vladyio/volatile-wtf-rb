require 'securerandom'
require 'set'

module Volatile
  class Storage
    attr_accessor :namespace

    def initialize(namespace = nil)
      @namespace = namespace || SecureRandom.hex[0..5]
      @keys = Set.new
      @manager = Manager.new
    end

    # Gets value by key (with a namespace)
    # Returns a `Volatile::Pair` instance, so that #modified and #created
    # are easily accessible.
    def [](key)
      key = namespaced_key(key)
      get(key)
    end

    # Sets value for a given key (with a namespace). Keeps the key for later
    # to use in `to_h`
    def []=(key, value)
      key = namespaced_key(key)
      @keys << key
      set(key, value)
    end

    # Gets value by key (without a namespace)
    # Returns a `Volatile::Pair` instance, so that #modified and #created
    # are easily accessible.
    def get(key)
      @manager.retrieve(key)
    end

    # Sets value for a given key (without a namespace)
    def set(key, value)
      @manager.store(key, value)
      { key => value }
    end

    # Refetch cached key
    def reload(key)
      @manager.reload(key)
    end

    def created(key, external: false)
      key = external ? key : namespaced_key(key)
      @manager.created(key)
    end

    def modified(key, external: false)
      key = external ? key : namespaced_key(key)
      @manager.modified(key)
    end

    # Generates a namespaced option for a key name
    def namespaced_key(key)
      "#{@namespace}_#{key}"
    end

    def to_h(use_namespace = false)
      manager = @manager

      @keys.each_with_object({}) do |key, hash|
        hash_key = use_namespace ? key : key.sub("#{@namespace}_", '')
        hash[hash_key] = manager.retrieve(key)
      end
    end
  end
end