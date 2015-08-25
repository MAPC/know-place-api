namespace :db do

  desc "Sample data tasks for the application."
  namespace :sample do

    desc "Load sample application data."
    task load: :environment do
      # files = Dir[File.expand_path("db/sample_data/*")]
      files.map do |p|
        yml   = YAML.load_file(p)
        yml.each_pair do |key, records|
          klass = Kernel.const_get(key.classify)
          records.each {|r| puts r.inspect; klass.create(r) }
        end
      end
    end

    desc "Clear out (delete) all sample application data."
    task clear: :environment do
      # files = Dir[File.expand_path("db/sample_data/*")]
      files.map do |p|
        yml   = YAML.load_file(p)
        yml.each_pair do |key, records|
          klass = Kernel.const_get(key.classify)
          records.each {|r| puts r.inspect; klass.destroy( r['id'] ) }
        end
      end
    end

  end
end

def files
  ["/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/data_sources.yml",
  "/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/fields.yml",
  "/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/data_points.yml",
  "/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/data_collections.yml",
  "/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/reports.yml",
  "/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/places.yml",
  "/Users/mapcuser/Projects/Neighborhood Drawing Tool/know-place-api/db/sample_data/profiles.yml"]
end