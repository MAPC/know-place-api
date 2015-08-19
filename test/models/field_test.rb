require "test_helper"

class FieldTest < ActiveSupport::TestCase
  def field
    @field ||= fields(:pop_2000)
  end

  def test_valid
    assert field.valid?
  end

  def test_requires_column_name_of_certain_length
    field.column_name = ""
    assert_not field.valid?
    field.column_name = "x" * 256
    assert_not field.valid?
  end

  def test_requires_a_datasource
    field.data_source = nil
    assert_not field.valid?
  end
end
