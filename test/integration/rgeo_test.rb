require "test_helper"

class RgeoTest < ActiveSupport::TestCase


  def test_rgeo_supports_geos
    assert RGeo::Geos.supported?
  end

  def test_rgeo_supports_proj
    assert RGeo::CoordSys::Proj4.supported?
  end

end