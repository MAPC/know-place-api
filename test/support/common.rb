module Common
  def set_content_type_header!
    @request.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
  end
end