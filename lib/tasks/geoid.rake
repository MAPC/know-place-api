require 'rake'
require 'optparse'

namespace :geoid do |args|
  desc 'Creates creates a geoid column by appending to the existing Census Tract ID'
  # environment is required to have access to Rails models
  task create: :environment do
    options = {}
    OptionParser.new(args) do |opts|
      opts.banner = "Usage: rake geoid:create [options]"
      opts.on("-t", "--table {table_name}","Table (without schema) to edit", String) do |table|
        options[:table] = table
      end
      opts.on("-c", "--column {column}","Column containing Census Tract IDs", String) do |column|
        options[:column] = column
      end
      opts.on("-p", "--prepend {text_to_prepend}","Text to prepend, default '14000US'", String) do |prepend|
        options[:prepend] = prepend
      end
    end.parse!

    table   = options.fetch(:table)   { raise ArgumentError, "No table given."   }
    column  = options.fetch(:column)  { 'ct10_id' }
    prepend = options.fetch(:prepend) { '14000US' }

    conn = GeographicDatabase.connection
    assert_column_does_not_exist(conn, table, :geoid)
    puts "Creating column #{table}.geoid by prepending #{prepend.inspect} to #{table}.#{column}..."
    create_column(conn, table, :geoid)
    assert_column_does_exist(conn, table, :geoid)
    exit 0
  end

  def assert_column_does_not_exist(conn, table, column)
    if conn.column_exists?(table, :geoid)
      puts "Column #{table}.geoid already exists, exiting."
      exit 0
    end
  end

  def assert_column_does_exist(conn, table, column)
    if conn.column_exists?(table, :geoid)
      puts "\t\t...created!"
    else
      puts "ERROR: column #{column} was not created!"
      exit 1
    end
  end

  def create_column(conn, table, column)
    conn.transaction do
      conn.execute "ALTER TABLE #{table} ADD COLUMN geoid text;"
      conn.execute "UPDATE #{table} SET geoid = '14000US' || ct10_id;"
    end
  end
end