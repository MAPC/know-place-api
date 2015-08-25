class ReportSerializer < ApplicationSerializer
  has_many :data_points
  has_many :data_collections

  def id
    object.to_param.to_s
  end

  attribute :title do
    object.title
  end

  attribute :description do
    object.description
  end

  attribute :official do
    object.official
  end
end