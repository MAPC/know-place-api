require "administrate/base_dashboard"

class ReportDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    # profiles: Field::HasMany,
    data_points: Field::HasMany.with_options(limit: 100),
    data_collections: Field::HasMany.with_options(limit: 100),
    id: Field::Number,
    title: Field::String,
    description: Field::String,
    official: Field::Boolean,
    tags: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    # :profiles,
    :data_points,
    :data_collections,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :title,
    :description,
    :data_points,
    :data_collections,
    :official,
    # :profiles,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :description,
    :official,
    :data_points,
    :data_collections
  ].freeze

  # Overwrite this method to customize how reports are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(report)
    "#{report.title}"
  end
end
