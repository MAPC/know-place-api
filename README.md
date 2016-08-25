# KnowPlace API

The geospatial API for KnowPlace, MAPC's neighborhood drawing and data tool.

## What is KnowPlace?

KnowPlace provides data summaries for any geography. Open the map, select or draw an outline of your neighborhood, city, or town, and select the kind of data (e.g. basic demographics, public health, etc.) you'd like to see. KnowPlace gives you a custom report about the place you outlined, including information about [margins of error][moe] to help you understand how reliable the data is.

KnowPlace [democratizes information][impl2] by giving users the power to access essential statistics for custom geometries, without needing to use costly or time-consuming mapping and statistics software.

In a sense, KnowPlace is simplified GIS without needing to know GIS.

> [What is GIS?][gis]

[moe]: https://en.wikipedia.org/wiki/Margin_of_error
[impl2]: http://www.mapc.org/sites/default/files/MF2_Information_11_21.pdf
[gis]: https://www.quora.com/Geographic-Information-Systems-GIS/What-is-GIS-1

#### What is the KnowPlace API?

The KnowPlace API powers the geographical and mathematical work behind the [KnowPlace client][client] that users interact with.

To summarize, the KnowPlace API:

- checks to make sure the geometry you've drawn is valid
- finds all the Census tracts intersecting with the drawn geometry
- calculates aggregate data and margins of error
- stores all the places, reports, and profiles
- authenticates and authorizes users

[client]: https://github.com/MAPC/neighborhood-drawing-tool-client

The API is not currently accessible to anything but the KnowPlace client, but we plan to make it publicly accessible, so you could send it a GeoJSON geometry and get back census tracts and data. Please see the [Roadmap][#roadmap] for more.

#### How It Works

The end result you see is called a __Place Profile__, or simply a __Profile__. A Profile provides detailed information about a place. The Profile shows a map of a place's boundary and the underlying Census Tract geometries used to summarize the data for that place. It lists all the data points, showing margins of error and color-coding them to indicate the degree of confidence it is safe to have in each piece of data.

For more on margin of error and confidence in data, see the section __["On Confidence"](#on-confidence)__.

This comes from combining a __Place__ with a __Report__.

A __Place__ is any geometry, either provided by MAPC or drawn and contributed by KnowPlace users.

> Some Places may be marked as "official" to indicate that they are official municipal boundaries provided by the Commonwealth of Massachusetts, or that they are the neighborhood boundaries used by official entities including the Boston Redevelopment Authority. Neighborhood boundaries are not always agreed-upon, so we intend the "official" tag to mean "provided by officials", as opposed to "correct" or "canonical".

A __Report__ is a grouping of data to provide information about a certain subject.

__DataPoints__ take one or more fields (database columns) and operate on them using __Aggregators__.

We first combine fields (database columns) with summation operations (Aggregators) in order to get DataPoints. In other words, DataPoints consist of several columns that have been operated on over a given set of records (more on that shortly).

> For example:

> In order to get a DataPoint called "Proportion of Adults with Bachelor's Degrees or Higher" We take the total number of adults (column `pop25`) and the number of adults with a bachelor's degree or higher (column `bapl`), and operate on those columns with an Aggregator that takes the sums of both columns, then divides to get the proportion.

A DataPoint can be classified under a topic. For example, DataPoints in the "Demographics" topic include:

- Ages 5-9 Native American
- Over 75 with disability
- People speaking non-English language who do not speak English at all

A __DataCollection__ is a grouping of related DataPoints that should be displayed together. For example, the DataCollection "Population by race and ethnicity" includes the following DataPoints, among others:

- Non-Latino White
- Latino
- Non-Latino Pacific Islander

This ensures that the data user or consumer can access related information in the same place, and compare categories at a glance.

A __Topic__ is a grouping of subject matter that MAPC uses across all its informational projects. Topics include Demographics, Civic Vitality & Governance, Environment & Energy, Public Health, and more.

#### Aggregators

Aggregators sum up all the data for a given set of records, in a query something like:

```sql
SELECT aggregator_name(column, column, etc) WHERE geoid IN ('list', 'of', 'geoids');
```

## On Confidence

TODO

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

You can run tests to check that everything is running using `rake test`. Keep tests running in the background with `guard`.

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

The KnowPlace API is a [Twelve-Factor app][12f], and will deploy on Heroku, Dokku, or similar cloud hosting services.

[12f]: https://12factor.net/

## Roadmap

- __Public API__ so other applicaitons services will be able to ask for a Place Profile by posting a GeoJSON polygon and a set of DataPoints or Report to the API endpoint, and get back the evaluated profile and the associated Census Tracts (and other underlying geographies, if any).
- __Simple charts and graphs__ to highlight key neighborhood indicators, and the ability to transpose data for multiple visualization tools' preferred data formats through an API call.
- __Comparison__ to see the similarities and differences between two places.
- __Support for multiple geometries__ including points, Census blocks and blockgroups, and non-Census geometries.

## Client Roadmap
- __Communicative interface__ that simplifies the process of profile creation, simplifies loading, and more.
- __Improved information design__ that presents data in a clearer way.
- __Export__ data to a spreadsheet format, or the profile with a map to PDF.
