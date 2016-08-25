# TODO: If we autoload this, then the connection will be established.
# Do we want that?
# This is not a Query object. This is an initializer, maybe. Maybe it's lib too.

class GeographicDatabase < ActiveRecord::Base

  # Mark this as abstract so it gets its own connection.
  # TODO: Source for this information?

  def self.abstract_class?
    true
  end
end

GeographicDatabase.establish_connection(:geographic)
