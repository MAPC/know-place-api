# JSONAPI Resources fails to take namespacing into account,
# so a URL might look like http://domain/namespace/namespace/resource/1.

# We don't want this behavior in this application, and even though we set
# the route's :path attributes to '', we still get this, though our desired
# URL is http://domain/resource/1.

module JSONAPI
  class LinkBuilder
    private

    def formatted_module_path_from_class(klass)
      '/'
    end
  end


end
