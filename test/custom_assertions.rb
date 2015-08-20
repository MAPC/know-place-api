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

  private

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
