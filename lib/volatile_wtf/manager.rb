require 'net/http'
require 'uri'

module Volatile
  # Manages the server side of Volatile storage, handles API requests
 class Manager
    def initialize
      @cache = Cache.new
    end

    def store(key, value)
      get_from api_uri key, value
      @cache.save(key, value)
    end

    def retrieve(key)
      @cache.fetch(key) { get_from api_uri key }
    end

    def reload(key)
      fresh_value = get_from api_uri key
      store(key, fresh_value)
    end

    def created(key)
      time = key_modificator key, :created
      Time.at(time.to_i)
    end

    def modified(key)
      time = key_modificator key, :modified
      Time.at(time.to_i)
    end

    private

    # API URI helper for accessing key modificators data
    def key_modificator(key, mod)
      get_from api_uri key, nil, mod
    end

    def get_from(uri)
      Net::HTTP.get(uri)
    end

    # Builds a Volatile API URI
    def api_uri(key = nil, value = nil, modifier = nil)
      url = "#{BASE_URL}/?key=#{key}"
      url << "&#{modifier}" if modifier
      url << "&val=#{value}" if value

      URI(url)
    end
  end
end
