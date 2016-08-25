class DataPoint < ActiveRecord::Base

  belongs_to :aggregator
  belongs_to :topic
  has_and_belongs_to_many :data_collections
  has_and_belongs_to_many :reports

  validates :aggregator_id, presence: true
  validate :all_fields_exist

  default_scope { order('updated_at DESC') }

  def field_array
    # TODO: We should strip whitespace when saving, and not at the end.
    # We should also consider making 'fields' a text array, so we don't
    # have to split strings every time.
    @field_arr ||= fields.split(',').map(&:strip)
  end

  # def evaluate(place)
  #   Evaluation::DataPoint.new data_point: self, place: place
  # end

  private

    # TODO: I think this was imaginary? I don't think this actually does this.
    def all_fields_exist
      conn = GeographicDatabase.connection
      messages = field_array.map do |field|
        unless conn.column_exists? "tabular.#{self.tables}", field
          "field #{field} in table #{self.tables} does not exist"
        end
      end
      messages.compact.each { |message| errors.add(:fields, message) }
    end

end
