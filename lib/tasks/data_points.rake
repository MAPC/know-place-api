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

      header
      tables.map do |table|
        status = table_status(table)
        puts "#{status}#{table}"
      end
      footer
    end

    def table_status(table)
      if GeographicDatabase.connection.table_exists? table
        "EXISTS #{good_keys?(table)}\t"
      else
        "MISSING\t\t\t"
      end
    end

    def good_keys?(table)
      conn  = GeographicDatabase.connection
      keys  = conn.execute "SELECT COUNT(*) FROM #{table} WHERE substring(geoid from '^.{7}') = '14000US';"
      count = conn.execute "SELECT COUNT(*) FROM #{table};"
      keys == conn ? "WITH GOOD IDS" : "BUT BAD IDS"
    end

    def header
      puts "\n"
      puts "STATUS / GEOIDS\t\tTABLE"
      puts "---------------------------------------------------------"
    end

    def footer
      # puts "========================================================="
      puts "\n"
    end

  end
end