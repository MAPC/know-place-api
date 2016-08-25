# TODO: More documentation.

class ProfileEvaluation

  attr_accessor :profile

  def initialize(_profile=nil, profile: _profile)
    # TODO turn these into better guard clauses
    profile or raise ArgumentError,
        "Must supply Profile object or ID"

    @profile = object_for profile, Profile
    # TODO this should have gone into the test
    # @profile.place.geoids = ['14000US25001010100']

    @profile.complete? or raise ArgumentError,
        "Profile to be evaluated must be complete"
  end

  def valid?
    @profile.complete?
  end

  def perform
    data_points = @profile.report.data_points.collect do |data_point|
      DataPointEvaluation.new(
        data_point: data_point,
        place: @profile.place
      ).perform
    end

    data_collections = @profile.report.data_collections.collect do |data_collection|
      DataCollectionEvaluation.new(
        data_collection: data_collection,
        place: @profile.place
      ).perform
    end

    { data: [ data_points, data_collections ].flatten }
  end

  private

  # TODO: Dry it up. This is duplicated elsewhere.
  def object_for(object_or_id, klass)
    case object_or_id
    when klass then object_or_id
    when Integer
      klass.find_by(id: object_or_id)
    else
      raise ArgumentError,
        "must provide a #{ klass } or a valid #{ klass } id"
    end
  end
end
