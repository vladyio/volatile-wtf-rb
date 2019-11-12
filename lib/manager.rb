require 'net/http'
require 'uri'

module Volatile
  class Manager
    def store(key, value)
      get_from uri_with key, value
    end

    def retrieve(key)
      get_from uri_with key
    end

    def created_at(key)
      resp = get_from uri_with key, nil, 'created'
      Time.at(resp.body.to_i)
    end
    alias created created_at

    def updated_at(key)
      resp = get_from uri_with key, nil, 'modified'
      Time.at(resp.body.to_i)
    end
    alias modified updated_at

    private

    def get_from(uri)
      Net::HTTP.get(uri)
    end

    def uri_with(key = nil, value = nil, modifier = nil)
      url = "https://volatile.wtf/?key=#{key}"
      url << "&#{modifier}" if modifier
      url << "&val=#{value}" if value

      URI(url)
    end
  end
end