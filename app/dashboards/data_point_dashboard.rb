require "administrate/base_dashboard"

class DataPointDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    aggregator: Field::BelongsTo,
    topic: Field::BelongsTo,
    data_collections: Field::HasMany.with_options(limit: 100),
    reports: Field::HasMany.with_options(limit: 100),
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    fields: Field::String,
    tables: Field::String,
    where: Field::String,
    units: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :topic,
    :data_collections,
    :reports,
    :updated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :aggregator,
    :topic,
    :data_collections,
    :reports,
    :id,
    :name,
    :created_at,
    :updated_at,
    :fields,
    :tables,
    :where,
    :units,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :topic,
    :aggregator,
    :fields,
    :tables,
    :where,
    
    
    :data_collections,
    :reports,


    
    :units,
  ].freeze

  # Overwrite this method to customize how data points are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(data_point)
    "#{data_point.name} (ID: #{data_point.id})"
  end
end
