class ApplicationController < ActionController::API

  DEFAULT_PER_PAGE = Kaminari.config.default_per_page
  DEFAULT_PAGE_NUM = 1

  def filter
    params.fetch(:filter) { {} }
  end

  def includes
    params.fetch(:include, "").split(',')
  end

  def page_number
    page.fetch(:number) { DEFAULT_PAGE_NUM }
  end

  # TODO: Factor out this duplicate logic (also in ApiHelper)
  def per_page
    page.fetch(:size) { DEFAULT_PER_PAGE }
  end

  # Convenience methods for serializing models
  def serialized_object(object)
    JSONAPI::Serializer.serialize(
      object, include: includes, is_collection: false
    )
  end

  def serialized_collection(collection)
    json = JSONAPI::Serializer.serialize(
      collection, include: includes, is_collection: true
    )
    json[:links] = paginate(collection)
  end

  private

    def page
      params.fetch(:page) { Hash.new }
    end
end
