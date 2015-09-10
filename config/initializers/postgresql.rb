#  Send supporting function definitions to the Postgres server
#  on application bootup. Some people use a db/structure.sql file
#  and run `rake db:structure:load` to set up views and functions.
#  This could also be done via a seed task, that loops through and
#  loads function definitions from, say, a YAML file.
#  Lastly, "supporting functions" could be its own resource, with
#  functions defined through the admin console.

#  However, since we want to ensure that these functions are
#  immediately loaded and ready for use, we'll DROP and re-CREATE
#  each function when the application is redeployed.

#  We don't claim this is ideal. However, it's one less step for
#  others setting this up in the future.

yml = YAML.load_file("db/functions/functions.yml")
drop_statements = yml.map{|k,v| v["drop"]}
definitions     = yml.map{|k,v| v["definition"]}
geo = GeographicDatabase.connection

drop_statements.each {|drop| geo.execute drop }
definitions.each {|create| geo.execute create }