# KnowPlace API

The API for the Neighborhood Drawing Tool.



## Setup

In this README, we refer to brand-new coders as _Beginners_, those who have the basics down as _Starters_, and all others as _Established_.

#### Established

__Get it!__

Clone it, and `bundle install`.

__Configure it!__

Most tasks depend on Foreman, and depends on a .env file being available in the root of the repository. __Make sure you never commit your .env file to source control, as it often contains highly sensitive information!__

In your terminal, run

```
mv .env.template .env
```

to rename `.env.template` to `.env`. Then, where you see placeholder descriptions, change those to actual values.

__Seed it!__

Populate the database with the data that is necessary to the core of the application with:

```
rake db:seed
```

Optionally, you can then populate the database with sample data by running

```
rake db:sample
```

__Test it!__

To run tests, run `rake test`, or to keep them running continually, run `bundle exec guard`.

__Run it!__

Run the server with `foreman start`, and the console with `foreman run rails console`.


#### Starters

Familiarize yourself with Foreman and how .env is used to store environment variables. You may also want to


#### Beginners

Start by learning how to set up Ruby and Rails on your machine. That's outside the scope of this README for the moment, but we plan to provide links later.



## Basic Data Structure

We first combine fields (columns) from our databases with summation operations (Aggregators) in order to get DataPoints. In other words, DataPoints consist of several columns that have been operated on over a given set of records (more on that shortly).

    For example:

    In order to get a DataPoint called "Proportion of Adults with Bachelor's Degrees or Higher" We take the total number of adults (column `pop25`) and the number of adults with a bachelor's degree or higher (column `bapl`), and operate on those columns with an Aggregator that takes the sums of both columns, then divides to get the proportion.


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




