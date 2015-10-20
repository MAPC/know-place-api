# KnowPlace API

The API for KnowPlace, the Neighborhood Drawing Tool.

## What is KnowPlace?

KnowPlace [democratizes information][impl2], giving users the power to access essential statistics for custom geometries, without needing to use costly or time-consuming mapping software.

When using KnowPlace

#### What is the KnowPlace API?

Most of the geometrical and mathematical work is done in the API, behind the scenes. When you draw a place, the API checks to see if it's a valid shape and finds all the underlying Census tracts. When build a new profile by combining a report and a place, it does all the calculations you need and sends you your custom data, in seconds.

Among other things, the KnowPlace API:

- checks to make sure the geometry you've drawn is valid
- finds all the Census tracts intersecting with the drawn geometry
- calculates aggregate data and margins of error
- stores all the places, reports, and profiles
- authenticates and authorizes users

In a sense, KnowPlace is simplified GIS without needing to know GIS.

> [What is GIS?][gis]

[gis]: https://www.quora.com/Geographic-Information-Systems-GIS/What-is-GIS-1


#### Basic Data Structure

We first combine fields (database columns) with summation operations (Aggregators) in order to get DataPoints. In other words, DataPoints consist of several columns that have been operated on over a given set of records (more on that shortly).

> For example:

> In order to get a DataPoint called "Proportion of Adults with Bachelor's Degrees or Higher" We take the total number of adults (column `pop25`) and the number of adults with a bachelor's degree or higher (column `bapl`), and operate on those columns with an Aggregator that takes the sums of both columns, then divides to get the proportion.

How do we know which records (rows) to take when we are summarizing? Well, first of all, each row is represented by either a single geographic point, or by a value assigned to a [Census Tract](https://en.wikipedia.org/wiki/Census_tract).

At the core, this application takes a defined geographic boundary ("Place") and combines it with a set of DataPoints, called a "Report", and creates what we call a "Place Profile", or simply a Profile.

On its own, a Report doesn't have any numerical values -- it _needs_ a Place in order to figure out which points and tracks to query.

When a user creates a geography, we first query for all of the Census Tracts that touch the user-defined geographic boundary. Next, we run the queries for all the DataPoints in the user's current Report, limiting the query to only the rows associated with the Census Tracts in the user's Place.

This produces the Profile, which is static unless someone changes the related Place or Report -- then the Profile is run again, in order to update its values.

#### Aggregators

Aggregators sum up all the data for a given set of records, in a query something like:

```sql
SELECT aggregator_name(column, column, etc) WHERE geoid IN ('list', 'of', 'geoids');
```

#### API

At the moment, the API is not CORS-enabled, meaning that only applications on the same domain are allowed to read from it. However, we plan to open it up once we rate-limit it.

External services will be able to ask for a Place Profile by posting a GeoJSON polygon and a set of DataPoints or Report to the API endpoint, and get back the evaluated profile and the associated Census Tracts (and other underlying geographies, if any).

[impl2]: http://www.mapc.org/sites/default/files/MF2_Information_11_21.pdf

## Preparation

This is a Ruby on Rails app and uses a PostgreSQL 9.3+ database. [See Code for America's "HowTo" guides][howto] for more information setting up and maintaining applications with [Rails][howrails] and [Postgres][howpg].

[howto]:    https://github.com/codeforamerica/howto
[howrails]: https://github.com/codeforamerica/howto/blob/master/Rails.md
[howpg]:    https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md



## Installation

[Clone this repository][clone]. Once you are in the folder, to install all of the dependenices, run

```sh
bundle install
```

The included [.ruby-gemset](.ruby-gemset) file will signal RVM or other Ruby managers to use a gemset called 'knowplace'. If you are also cloning [the KnowPlace client][client], you can use this gemset when installing any client-side gems.

[clone]: https://18f.gsa.gov/2015/03/03/how-to-use-github-and-the-terminal-a-guide/#clone-a-repo-on-your-computer
[client]: https://github.com/MAPC/neighborhood-drawing-tool-client


## Configuration

We use [Foreman][foreman] to manage this application. Foreman looks for a .env file in the root project folder, and expects key-value pairs.

You will never deploy using the .env file -- you'll use configuration variables in your production environment.

__Please make sure you never commit your .env file to source control, as it can contain highly sensitive information.__

To set up Foreman, rename the .env.template file to .env.

```
# Move (rename) the template to .env
mv .env.template .env
```

Change the placeholder descriptions to actual values, or delete lines when you're using the defaults.

## Data

#### Populate the Census and ACS data.

> This task is not straightforward, as the application depends on a complete set of 2010 Census tracts, and each Data Point relies on tabular data that is not verified to be in the database. We spent our time building a functional prototype, not a robust data management system. We are accepting contributions that bring us towards such a system.

The application expects the following.

- A database named 'geographic' on the same database server as the application database.
    - This database server should be running PostgreSQL 9.3 or higher. We haven't tested it any lower.
    - This database must have PostGIS installed.
- A full set of Massachusetts 2010 Census tracts, in a table called `census_tracts_2010`.
    - We recommend storing this in a schema named `spatial`, but this is not required.
- Tabular (i.e. not spatial) data that supports the data points you expect to include.
    - We recommend storing this data in a schema named `tabular`.

#### Add base-level data.

Populate the database with data.

> This process is still a bit messy and scattered across a few files, based on the fact that we took multiple approaches during development. We are happy to accept contributions for this area.

```
# Add essential data for the application to operate.
rake db:seed

# Load data points from db/fixtures/data_points.csv.
# This requires that the underlying tabular data is already present,
# per the above step.
rake data:points:load

# Load reports that use the loaded data points.
rake data:reports:load

# Check to make sure all of the underlying tabular (i.e. not
# spatial) tables are in good working order.
rake data:tables:status

# List all the ACS years for each table. Data points specify which
# year to use, so we need to ensure the right years are in the data.
rake data:tables:years
```

## Testing

We use a [test-driven development methodology][tdd] to ensure our code does what we expect it to.
[tdd]: http://martinfowler.com/bliki/TestDrivenDevelopment.html

You can run tests to check that everything is running.

```sh
# Run tests explicitly.
rake test

# Run tests, when 'test' is the default rake task.
rake
```

To keep tests running continually in the background, we use Guard. You can start Guard in a Terminal pane or window with, simply,

```
guard

# or if that doesn't quite work, try
bundle exec guard
```

## Running the application

> The processes that are started by Foreman are located in the [Procfile](Procfile). Running the Rails console with Foreman ensures that the environment variables in your .env file are included in the application when running the console. (Running `rails c` on its own won't get those variables.)

#### Server

Run the Rails server with

```sh
foreman start
```

#### Console and more
Run the Rails console with

```sh
foreman run rails console
```

Assuming the operation of your application depends on the environment variables stored in your .env file, preface any normal command with `foreman run` to load the .env variables into the application environment.

For example, if you are running a rake task that needs the .env, run

```sh
foreman run rake some_task
```

## Deployment

If you don't have a preferred deployment service, or are willing to try out a self-hosted Platform as a Service, we recommend using [Dokku Alt](https://github.com/dokku-alt/dokku-alt) on servers running Ubuntu 14.04. [(See Dokku requirements.)](https://github.com/dokku-alt/dokku-alt#requirements)

Dokku is very similar to other cloud PaaSes, but is fairly straightforward to set up if you're comfortable with SSH, public/private keys, and navigating and installing things on Linux servers.


