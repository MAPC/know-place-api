module Common::TestJsonApiConventions
  def test_attributes_not_empty
    assert_not_empty attributes
  end

  def test_id_is_param
    assert_equal resource.to_param.to_s, data["id"], s
  end
end