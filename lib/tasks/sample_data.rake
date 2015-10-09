namespace :db do
  desc "Update / sync primary key."
  namespace :sample do
    task keys: :environment do
      %w( places reports profiles ).each { |table|
        ActiveRecord::Base.connection.reset_pk_sequence! table
      }
    end
  end
end

namespace :db do

  desc "Sample data tasks for the application."
  namespace :sample do

    desc "Load sample application data."
    task load: :environment do
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
      files.map do |p|
        yml   = YAML.load_file(p)
        yml.each_pair do |key, records|
          klass = Kernel.const_get(key.classify)
          records.each do |r|
            id = r['id']
            klass.destroy( id ) if klass.find_by(id: id)
          end
        end
      end
    end

  end
end

def files
  # Loaded in order so dependencies are in place at the right time.
  # FIx this so it runs on the thing
  [#File.expand_path("data_sources.yml",     "./db/sample_data/"),
   #File.expand_path("fields.yml",           "./db/sample_data/"),
   #File.expand_path("data_points.yml",      "./db/sample_data/"),
   #File.expand_path("data_collections.yml", "./db/sample_data/"),
   File.expand_path("reports.yml",          "./db/sample_data/"),
   File.expand_path("places.yml",           "./db/sample_data/"),
   File.expand_path("profiles.yml",         "./db/sample_data/")]
end