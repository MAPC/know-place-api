require "administrate/base_dashboard"

class PlaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    profiles: Field::HasMany,
    user: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    description: Field::String,
    geometry: Field::String.with_options(searchable: false),
    tags: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    completed: Field::Boolean,
    underlying_geometries: Field::String.with_options(searchable: false),
    geoids: Field::Text,
    municipality: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :profiles,
    :user,
    :id,
    :name,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :profiles,
    :user,
    :id,
    :name,
    :description,
    :geometry,
    :tags,
    :created_at,
    :updated_at,
    :completed,
    :underlying_geometries,
    :geoids,
    :municipality,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :profiles,
    :user,
    :name,
    :description,
    :geometry,
    :tags,
    :completed,
    :underlying_geometries,
    :geoids,
    :municipality,
  ].freeze

  # Overwrite this method to customize how places are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(place)
  #   "Place ##{place.id}"
  # end
end
