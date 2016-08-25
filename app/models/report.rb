class Report < ActiveRecord::Base
  include PgSearch

  has_many :profiles, dependent: :nullify
  has_and_belongs_to_many :data_points
  has_and_belongs_to_many :data_collections

  validates :title,       presence: true, length: { minimum:  5, maximum:  70 }
  validates :description, presence: true, length: { minimum: 20, maximum: 140 }

  pg_search_scope(
    :search,
    against: {
      title:       'A',
      tags:        'B',
      description: 'C'
    },
    using: {
      tsearch: {
        dictionary: 'english',
        prefix: true
      }
    }
  )
end
