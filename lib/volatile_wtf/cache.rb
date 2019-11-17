module Volatile
  class Cache
    attr_reader :storage

    def initialize
      @storage = {}
    end

    def save(key, value)
      @storage[key] = value
    end

    def fetch(key, &block)
      @storage.fetch(key, &block)
    end
  end
end