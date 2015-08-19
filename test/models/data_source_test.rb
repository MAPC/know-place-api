require "test_helper"
require "uri"

class DataSourceTest < ActiveSupport::TestCase
  def data_source
    @data_source ||= DataSource.new
  end

  def test_requires_a_string
    assert_not data_source.valid?
  end

  def test_requires_valid_uri
    url = "postgres://user:pass@address:9067/database_name"
    data_source.database_url = url
    assert_nothing_raised(URI::InvalidURIError) { URI.parse(url) }
    assert data_source.valid?
  end

  def test_rejects_invalid_uri
    url = "postgres://user:p@ss@0000:9067/00"
    data_source.database_url = url
    assert_raises(URI::InvalidURIError) { URI.parse(url) }
    assert_not data_source.valid?
  end
end
