errors = c()

# Test helper functions
assert_equal <- function(expected, actual) {
  assert( equal(expected, actual), paste("Expected: ", expected, "\n  Actual: ", actual) )
}

assert <- function(function_name, error_message) {
  ifelse (function_name) {
    cat(".")
    return(TRUE)
  } else {
    cat("F")
    append(errors, error_message)
    return(FALSE)
  }
}

equal <- function(expected, actual) {
  if (expected == actual) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

report_out <- function(errors) {
  for error in errors
    print error
}





# R You Testing Your Code?

source('./test_helper.r')

library(RPostgreSQL)
db = dbConnect(dbDriver("PostgreSQL")
      host=''
      port=''
      dbname=''
      user=''
      password='')

#ACS MUNI LEVEL data from PostgreSQL Database
table <- "b15002_educational_attainment_acs_m"
#ACS_eduattain_muni <- fetch(dbSendQuery(db, "select * from b15002_educational_attainment_acs_m"), n = -1)
geoids <- "('06000US2502507000', '06000US2501711000', '06000US2501762535', '06000US2502155745')"

# Test
# 1. Define function
function_name <- "name_of_the_function_to_test"
function_def  <- paste("CREATE OR REPLACE ", function_name, " ", "function definition here...")
load_function <- dbSendQuery(db, function_def)
# 2. Call function
query <- paste(
  "SELECT ",
   function_name, "(column::type, column::type)",
  "FROM ", table,
  "WHERE geoid IN ", geoids
)

expected <- 578192
actual   <- fetch( dbSendQuery(db, query) )
status   <- assert_equal(expected, actual)

# Report-Out

report_out(errors)