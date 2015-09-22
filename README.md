# KnowPlace API

The API for the Neighborhood Drawing Tool.



## Installation and Setup

This is a Ruby on Rails app and uses a PostgreSQL 9.4+ database. See Code for America's "HowTo" on Rails for more information on deploying and maintaining apps using Rails: https://github.com/codeforamerica/howto/blob/master/Rails.md

This will not work with PostgreSQL 9.3 or lower, as they do not support the JSON functions needed for the SQL functions in this application to run. We intend to make it backwards-compatible, but have not yet addressed this.

#### Get it!

Clone it, and `bundle install`.

#### Configure it!

Most tasks depend on Foreman, and depends on a .env file being available in the root of the repository. __Make sure you never commit your .env file to source control, as it often contains highly sensitive information!__

In your terminal, run

```
mv .env.template .env
```

to rename `.env.template` to `.env`. Then, where you see placeholder descriptions, change those to actual values.

#### Seed it!

Populate the database with the data that is necessary to the core of the application with:

```
rake db:seed
```

Optionally, you can then populate the database with sample data by running

```
rake db:sample:load
```

Done with sample data, and want to clear it out? Assuming you haven't changed any IDs of the sample data records, just run a friendly

```
rake db:sample:clear
```

#### Test it!

To run tests, run `rake test`, or simply `rake`.

To keep tests running continually in the background, run

```
bundle exec guard
```

#### Run it!

Run the server with `foreman start`, and the console with `foreman run rails console`.

The processes that are started by Foreman are located in the [Procfile](Procfile). Running the Rails console with Foreman ensures that the environment variables in your .env file are included in the application when running the console. (Running `rails c` on its own won't get those variables.)


## Deployment

If you don't have a preferred deployment service, or are willing to try out a self-hosted Platform as a Service, we recommend using [Dokku Alt](https://github.com/dokku-alt/dokku-alt) on provisioned servers running Ubuntu 14.04. [(See Dokku requirements.)](https://github.com/dokku-alt/dokku-alt#requirements)

It's very similar to other cloud PaaSes, but is fairly straightforward to set up if you're comfortable with SSH, public/private keys, and navigating and installing things on Linux servers.


## Basic Data Structure

We first combine fields (columns) from our databases with summation operations (Aggregators) in order to get DataPoints. In other words, DataPoints consist of several columns that have been operated on over a given set of records (more on that shortly).

> For example:

> In order to get a DataPoint called "Proportion of Adults with Bachelor's Degrees or Higher" We take the total number of adults (column `pop25`) and the number of adults with a bachelor's degree or higher (column `bapl`), and operate on those columns with an Aggregator that takes the sums of both columns, then divides to get the proportion.


How do we know which records (rows) to take when we are summarizing? Well, first of all, each row is represented by either a single geographic point, or by a value assigned to a [Census Tract](https://en.wikipedia.org/wiki/Census_tract).


At the core, this application takes a defined geographic boundary ("Place") and combines it with a set of DataPoints, called a "Report" or "Template", and creates what we call a "Place Profile", or simply a Profile.

On its own, a Report doesn't have any numerical values -- it _needs_ a Place in order to figure out which points and tracks to query.

When a user creates a geography, we first query for all of the Census Tracts that touch the user-defined geographic boundary. Next, we run the queries for all the DataPoints in the user's current Report, limiting the query to only the rows associated with the Census Tracts in the user's Place.

This produces the Profile, which is static unless someone changes the related Place or Report -- then the Profile is run again, in order to update its values.





## Core Functionality

#### Aggregators

Aggregators sum up all the data for a given set of records, in a query like:

```sql
SELECT aggregator_name(column, column) WHERE geoid IN (list, of, geoids)
```


#### API

At the moment, the API is not CORS-enabled, meaning that only applications on the same domain are allowed to read from it. However, we plan to open it up once we rate-limit it.

External services will be able to ask for a Place Profile by posting a GeoJSON polygon and a set of DataPoints to the API endpoint, and get back the evaluated profile and the associated Census Tracts (and other underlying geographies, if any).


## Notes

- When you create an aggregator, we do not presently validate whether the plpgsql or SQL you are making into the function definition is valid. Ensure your SQL/plpgsql works beforehand using PgAdmin or some other tool, and only then set it to be the function body.




