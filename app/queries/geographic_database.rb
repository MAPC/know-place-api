# TODO: If we autoload this, then the connection will be established.

class GeographicDatabase < ActiveRecord::Base
  def self.abstract_class?
    true # So it gets its own connection
  end
end

GeographicDatabase.establish_connection(:geographic)
