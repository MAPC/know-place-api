require 'minitest/assertions'

module Minitest::Assertions

  #
  #  Fails unless +json contains string +key.
  #
  def assert_json_keys(json, keys)
    assert json_keys(json, keys),
      """Expected to find #{"key".pluralize(keys.length)}
         #{ Array(keys).map{|k| k.to_s}.join(', ') } in json:\n#{ json.keys.inspect }"""
  end

  #
  #  Fails if +json contains string +key.
  #
  def refute_json_keys(json, keys)
    refute json_keys(json, keys),
      """Found #{"key".pluralize(keys.length)}
         #{ Array(keys).map{|k| k.to_s}.join(', ') } in json:\n#{ json.keys.inspect }"""
  end

  alias_method :assert_json_key, :assert_json_keys
  alias_method :refute_json_key, :refute_json_keys

  #
  #  Fails if +obj is not a collection proxy for +class
  #
  def assert_collection_proxy(klass, collection)
    assert collection_proxy(klass, collection),
      """
      Expected collection #{ collection.inspect } to be a
      #{ collection_proxy_class_for(klass) }
      """
  end
  #
  #  Fails if +obj is a collection proxy for +class
  #
  def refute_collection_proxy(klass, collection)
    refute collection_proxy(klass, collection),
      """
      Expected collection #{ collection.inspect } to not be a
      #{ collection_proxy_class_for(klass) }, but it was.
      """
  end

  private

  def collection_proxy(klass, collection)
    collection_proxy_class = collection_proxy_class_for(klass)
    collection_class = collection.class
    collection_proxy_class == collection_class
  end

  def collection_proxy_class_for(klass)
    c = klass.to_s
    Kernel.const_get "#{c}::ActiveRecord_Associations_CollectionProxy"
  end

  def json_keys(json, keys)
    Array(keys).each { |key|
      return false if !parsed_json(json).keys.include?(key.to_s)
    }
  end

  def parsed_json(json)
    if json.is_a? Hash
      json
    else
      JSON.parse( json.to_s )
    end
  end

end
