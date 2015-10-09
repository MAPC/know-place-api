namespace :data do

  desc "Data points, collections, etc. for aggregation."
  namespace :points do
    desc "Load data points and related records."
    task load: :environment do
      SpreadsheetConverter.new('db/fixtures/data_points.csv').perform!
    end
  end

  desc "Check that tables are there."
  namespace :tables do
    desc "Check that all the expected tables are in."
    task check: :environment do
      tables = DataPoint.find_each.map(&:tables).uniq!
      tables.map do |table|
        puts "#{table_exists?(table)}\t\t#{table}"
      end
    end

    def table_exists?(table)
      if GeographicDatabase.connection.table_exists? table
        "      √"
      else
        "MISSING"
      end
    end

  end
end