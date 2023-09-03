using Tidier
using TidierStrings
using DataFrames, Chain

df = DataFrame(
  Names = ["Alice", "Bob", "Charlie", "Dave", "Eve", "Frank", "Grace"],
  City = ["New York        2019-20", "Los    \n\n\n\n\n\n    Angeles 2007-12 2020-21", "San Antonio 1234567890         ", "       New York City", "LA         2022-23", "Philadelphia            2023-24", "San Jose               9876543210"],
  Occupation = ["Doctor", "Engineer", "Final Artist", "Scientist", "Physician", "Lawyer", "Teacher"],
  Description = ["Alice is a doctor in New York",
                 "Bob is is is an engineer in Los Angeles",
                 "Charlie is an artist in Chicago",
                 "Dave is a scientist in Houston",
                 "Eve is a physician  in Phoenix",
                 "Frank is a lawyer in Philadelphia",
                 "Grace is a teacher in San Antonio"]
)

# Support Regex: `str_detect`, `str_replace`, `str_replace_all`, `str_remove`, `str_remove_all` `str_count`, `str_equal`, `str_subset`

# ## `str_squish()`
# Removes leading and trailing white spaces from a string and also replaces consecutive white spaces in between
# words with a single space. It will also remove new lines.

df = @chain df begin
    @mutate(City = str_squish(City))
end

# ## `str_replace()`, `str_replace_all`
# Replaces the first occurrence of a pattern in a string with a specified text. Takes a string, pattern to search for, and the replacement text as arguments. It also supports the use of regex and logical operator | . This is in contrast to `str_replace_all()` which will replace each occurence of a match within a string.

@chain df begin
  @mutate(City = str_replace(City, r"\s*20\d{2}-\d{2,4}\s*", " ####-## "))
  #@mutate(Occupation = str_replace_all(Occupation, "Doctor | Physician ", "Doctor"))
  @mutate(Description = str_replace(Description, "is | a", "4 "))

end

# ## `str_remove()`, `str_remove_all()`
# These functions will remove the first occurence or all occurences of a match, respectively.

@chain df begin
    @mutate(split = str_remove_all(Description, "is"))
end


# ## `str_detect()`
# Checks if a pattern exists in a string. It takes a string and a pattern as arguments and returns a boolean indicating
# the presence of the pattern in the string. This can be used inside of `@filter`, `@mutate`, `if_else()` and `case_when()`.
# `str_detect` supports logical operators `|` and `&`. `case_when()` with `filter()` and `str_detect()`.

@chain df begin
    @mutate(Occupation = if_else(str_detect(Occupation, "Doctor | Physician"), "Physician", Occupation))
    @filter(str_detect(Description, "artist | doctor"))
end

# and

@chain df begin
    @mutate(state = case_when(str_detect(City, "NYC | New York") => "NY", 
        str_detect(City, "LA | Los Angeles | San & Jose") => "CA", true => "other"))
end


# ## `str_equal()`
# Checks if two strings are exactly the same. Takes two strings as arguments and returns a boolean indicating
# whether the strings are identical.

@chain df begin
    @mutate(Same_City = case_when(str_equal(City, Occupation) => "Yes", true => "No"))
end

# ## `str_to_upper()`, `str_to_lower()`
#  These will take a string and convert it to all uppercase or lowercase

@chain df begin
    @mutate(Names = str_to_upper(Names))
end


# ## `str_subset()`
# Returns the subset of strings that match a pattern. Takes a vector of strings and a pattern as arguments
# and returns the subset of strings that contain the pattern.

@chain df begin
    @mutate(split = str_subset(Description, "artist"))
end