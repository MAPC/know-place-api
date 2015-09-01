class ReportResource < JSONAPI::Resource
  attributes :title, :description, :official

  has_many :data_points
  has_many :data_collections
end
