# This file contains all the data necessary to run the application
# at a basic level.
#
# To load sample data to test out the application, see sample_data.rb.

#   Get all files in fixtures
#   Loop through, checking the first key for the model name
#   Convert the model name to a constant and load the yml as records.


files = Dir[File.expand_path("db/fixtures/*.yml")]
files.map do |p|
  yml   = YAML.load_file(p)
  puts yml
  yml.each_pair do |key, records|
    klass = Kernel.const_get(key.classify)
    records.each do |r|
      begin
        klass.create(r)
      rescue => e
        "ImportError: #{e}\n\t record:  \t#{r.inspect}"
      end
    end
  end
end
