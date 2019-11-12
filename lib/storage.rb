require 'securerandom'

module Volatile
  class Storage
    attr_accessor :salt
    attr_reader :key, :value

    def initialize(salt = nil)
      @salt = salt || SecureRandom.hex[0..5]
      @keys = Set.new
      @manager = Manager.new
    end

    def [](key)
      @manager.retrieve(real_key(key))
    end

    def []=(key, value)
      @keys << real_key(key)
      @manager.store(real_key(key), value)
    end

    def pull(key)
      @manager.retrieve(key)
    end

    def push(key, value)
      @manager.store(key, value)
      { key => value }
    end

    def real_key(key)
      "#{@salt}_#{key}"
    end

    def to_h(with_real_keys = false)
      manager = @manager

      @keys.each_with_object({}) do |key, hash|
        hash_key = with_real_keys ? key : key.sub("#{@salt}_", '')
        hash[hash_key] = manager.retrieve(key)
      end
    end
  end
end