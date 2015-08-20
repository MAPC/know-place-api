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


## Notes

- When you create an aggregator, we cannot tell whether the plpgsql or SQL you are making into the function definition is valid. Ensure your SQL/plpgsql works beforehand using PgAdmin or some other tool, and only then set it to be the function body.






