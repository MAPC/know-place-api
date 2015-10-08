namespace :data do

  desc "Data points, collections, etc. for aggregation."
  namespace :points do

    desc "Load data points and related records."
    task load: :environment do

      SpreadsheetConverter.new('db/fixtures/data_points.csv').perform!

    end
  end
end