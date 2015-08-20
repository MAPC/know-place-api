# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

{
  data: {
    id: "91",
    type: "places",
    attributes: {
      name: "Dewey Square",
      description: "My neighborhood that I live in and it is the best",
      geometry: { type: "Polygon",
        coordinates: [
          [
            [-84.32281494140625,34.9895035675793],
            [-81.73690795898438,36.41354670392876],
            [-83.616943359375,34.99850370014629],
            [-84.05639648437499,34.985003130171066],
            [-84.22119140625,34.985003130171066],
            [-84.32281494140625,34.9895035675793]
          ]
        ]
      },
      relationships: {
        creator:  {links: {}, data: {type: "users",id: "13"}  },
        based_on: {links: {}, data: {type: "places",id: "90"} }
      }
    }
  },
  links: {},
  included: {}
}