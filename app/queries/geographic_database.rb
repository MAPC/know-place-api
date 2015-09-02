class GeographicDatabase < ActiveRecord::Base
  def self.abstract_class?
    true # So it gets its own connection
  end
end

GeographicDatabase.establish_connection(:geographic)