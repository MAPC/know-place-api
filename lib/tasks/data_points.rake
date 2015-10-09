namespace :data do

  desc "Data points, collections, etc. for aggregation."
  namespace :points do
    desc "Load data points and related records."
    task load: :environment do
      SpreadsheetConverter.new('db/fixtures/data_points.csv').perform!
      puts "Loaded #{DataPoint.count} data points!"
    end
  end

  desc "Check that tables are there."
  namespace :tables do
    desc "Check that all the expected tables are in."
    task status: :environment do
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
      geoid = conn.column_exists?(table, 'geoid')
      return "NO COLUMN 'GEOID'" unless geoid
      keys  = conn.execute "SELECT COUNT(*) FROM #{table} WHERE substring(geoid from '^.{7}') = '14000US';"
      count = conn.execute "SELECT COUNT(*) FROM #{table};"
      nums  = [keys, count].map! {|result| result.first['count'].to_i }
      nums.uniq.length == 1 ? "WITH GOOD IDS" : "BUT BAD IDS"
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