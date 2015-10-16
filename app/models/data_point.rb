class DataPoint < ActiveRecord::Base

  belongs_to :aggregator
  belongs_to :topic
  has_and_belongs_to_many :data_collections
  has_and_belongs_to_many :reports

  validates :aggregator_id, presence: true
  validate :all_fields_exist

  def field_array
    @field_arr ||= fields.split(',').map(&:strip)
  end

  private

    def all_fields_exist
      conn = GeographicDatabase.connection
      messages = field_array.map do |field|
        if conn.column_exists?( "tabular.#{self.tables}", field )
          "field #{field} in table #{self.tables} does not exist"
        end
      end
      messages.each { |message| errors.add(:fields, message) }
    end

end