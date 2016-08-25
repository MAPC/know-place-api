class Profile < ActiveRecord::Base
  before_save :evaluate!
  # TODO:
  # The before hook should only re-evaluate if the profile has not
  # yet been saved. There should be a safe #evaluate that won't save
  # if there's an existing evaluation, and an #evaluate that forces
  # the re-evaluation.

  belongs_to :place
  belongs_to :report
  belongs_to :user

  def title
    # TODO - Be more deliberate about handling titles
    # when we know it's not completed.
    # We could do this as a service object.
    "#{ report.try(:title) } in #{ place.try(:title) }"
  end

  def self.complete
    # Is there a better way to write this?
    where('place_id IS NOT NULL AND report_id IS NOT NULL')
  end

  # TODO
  # Make this a process object, with a complete! method
  # that completes things and sets the flags.
  def complete?
    place.present? && report.present?
  end
  alias_method :complete, :complete?

  def incomplete?
    !complete?
  end

  def evaluated?
    evaluated_at.presence
  end

  def not_yet_evaluated?
    !evaluated?
  end

  def evaluate!
    evaluate
  end

  private

  def evaluate
    if complete?
      assign_attributes(
        evaluation:   ProfileEvaluation.new(profile: self).perform,
        evaluated_at: Time.now
      )
    end
  end
end
