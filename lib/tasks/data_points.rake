namespace :data do

  desc "Data points, collections, etc. for aggregation."
  namespace :points do

    # Before running this task, ensure the following keys are in:
    #   Topic Area, Collection, Datapoint, Table, Subset Est,
    #   Subset MOE, Universe Est, Universe MOE, Estimate Units,
    #   Percent Units, Estimate Aggregator, Percent Aggregator,
    #   Estimate Fields, Percent Fields
    #
    # Remove all the fields that don't have values for Table.
    # Copy the file to data_points.csv.
    # Delete all existing data points, collections, and reports,
    #   but only in development.
    # Run this task
    #
    desc "Load data points and related records."
    task load: :environment do
      points, collections = DataPoint.count, DataCollection.count
      SpreadsheetConverter.new('db/fixtures/data_points.csv').perform!
      points_after, collections_after = DataPoint.count, DataCollection.count
      diff_points = points_after - points
      diff_collections = collections_after - collections
      puts "Loaded #{diff_points} data points\nand #{diff_collections} collections!"
    end
  end

  namespace :reports do
    task load: :environment do
      yml = YAML.load_file('db/fixtures/reports.yml')
      reports = yml.fetch('reports') { raise ArgumentError, "No key 'reports' in reports.yml." }
      reports.each do |r|
        data = OpenStruct.new(r)
        report = Report.new(title: data.name, description: data.description)
        report.data_points = data.data_points.map {|name|
          DataPoint.find_by(name: name)
        }.compact
        report.data_collections = data.data_collections.map {|name|
          DataCollection.find_by(title: name)
        }.compact

        if report.valid?
          report.save
        else
          puts "Invalid report:\n #{report.errors.full_messages}"
          exit 1
        end
      end
      exit 0
    end

    task create_universe: :environment do
      title = "All Available Data"
      desc = "All available data points and collections."
      tags = ['all', 'everything', 'universe', 'data']

      report = Report.find_by(title: title)
      if report
        puts "Report '#{title}' already exists, exiting."
        exit 0
      end
      new_report = Report.new(title: title, description: desc, tags: tags, official: true)
      new_report.data_points = DataPoint.all
      new_report.data_collections = DataCollection.all
      if new_report.valid?
        new_report.save!
        points_count = new_report.data_points.count
        collections_count = new_report.data_collections.count
        puts "Created Report '#{title}' with #{points_count} data points and #{collections_count} collections."
        exit 0
      else
        puts "New report #{new_report.inspect} was not valid:"
        puts new_report.errors.full_messages
        exit 1
      end

    end
  end

  desc "Check that the ACS years are correct"
  namespace :tables do
    task years: :environment do
      include PgArrayParser
      tables = DataPoint.find_each.map(&:tables).uniq!
      if Array(tables).empty?
        puts "There are no required tables. Note: there are #{DataPoint.count} data points."
        exit 1
      end
      tables.map do |table|
        status = table_years(table)
        puts "#{status}\t\t\t#{table}"
      end
      exit 0
    end

    def table_years(table)
      conn = GeographicDatabase.connection
      if conn.table_exists?(table) && conn.column_exists?(table, 'acs_year')
        result = conn.execute("SELECT array_agg(DISTINCT(acs_year)) FROM #{table}").first
        years = parse_pg_array(result['array_agg'])
        years.join(',')
      else
        "MISSING table #{table}\n\tor acs_year column."
      end
    end
  end

  desc "Check that tables are there."
  namespace :tables do
    desc "Check that all the expected tables are in."
    task status: :environment do
      tables = DataPoint.find_each.map(&:tables).uniq!
      if Array(tables).empty?
        puts "There are no required tables. Note: there are #{DataPoint.count} data points."
        exit 1
      end

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


def set_where_condition(options={})
  sum     = Aggregator.find_by(name: 'sum_and_moe')
  percent = Aggregator.find_by(name: 'percent_and_moe')
  ids     = assert_aggregators_present(sum, percent)

  where_clause = options.fetch(:clause) { "acs_year='2009-13'" }
  ids.each do |agg_id|
    data_points = DataPoint.where(aggregator_id: agg_id)
    data_points.each {|d|
      d.update_attributes(where: where_clause)
    }
    puts "Updated #{data_points.count} with WHERE clause #{where_clause}"
  end
end

def assert_aggregators_present(sum, percent)
  if [sum, percent].include?(nil)
    puts "The necessary aggregators are not present."
    puts "Sum\t#{sum}\nPercent\t#{percent}"
    return
  else
    [sum.id, percent.id]
  end
end