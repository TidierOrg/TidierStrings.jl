module TidierStrings
export str_detect, str_replace, str_replace_all, str_removal_all, str_remove, str_count, str_squish, str_equal, str_to_upper, str_to_lower, str_split, str_subset



"""
    str_detect(column::String, pattern::Union{String, Regex})

Check if `pattern` exists in the `column`. If the pattern is a string, this function
checks for exact matches. If the pattern is a regex, this function checks for regex matches.

# Arguments
- `column::String`: the string to search within.
- `pattern::Union{String, Regex}`: the pattern to search for.

# Returns
- `Bool`: `true` if the pattern is found in the column, `false` otherwise.

# Examples
```julia
str_detect("hello world", "hello") # returns true
str_detect("hello world", r"world") # returns true
"""
function str_detect(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 
    if pattern isa String
        or_groups = split(pattern, '|')

        or_results = []
        for or_group in or_groups
            and_patterns = split(or_group, '&')

            and_results = []
            for and_pattern in and_patterns
                trimmed_pattern = strip(and_pattern)
                push!(and_results, occursin(trimmed_pattern, column))
            end

            push!(or_results, all(and_results))
        end

        return any(or_results)
    else
        # For regular expressions, directly use occursin
        return occursin(pattern, column)
    end
end

"""
`str_replace`

    str_replace(column::String, pattern::Union{String, Regex}, replacement::String)

Replace the first occurrence of `pattern` in `column` with `replacement`. If the pattern is a string, 
this function replaces exact matches. If the pattern is a regex, this function replaces regex matches.

# Arguments
- `column::String`: the string in which to replace.
- `pattern::Union{String, Regex}`: the pattern to replace.
- `replacement::String`: the string to replace the pattern with.

# Returns
- `String`: the updated string with the first instance of the pattern replaced.

# Examples
```julia
str_replace("hello world", "hello", "hi") # returns "hi world"
str_replace("hello world", r"world", "there") # returns "hello there"
"""
function str_replace(column::Union{Missing, String}, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        first_occurrences = [(p, findfirst(p, column)) for p in patterns]
        # Filter out patterns that were not found
        found_occurrences = filter(x -> x[2] !== nothing, first_occurrences)
        # If none of the patterns are found, return the original column
        if isempty(found_occurrences)
            return column
        end
        # Get the first pattern among the found patterns
        first_pattern = sort(found_occurrences, by = x -> x[2].start)[1][1]
        # Replace the first occurrence of the first found pattern
        column = replace(column, first_pattern * r"\b" => replacement, count = 1)
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern * r"\b" => replacement, count = 1) # Only replace the first occurrence
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end


"""
`str_replace_all`

    str_replace_all(column::String, pattern::Union{String, Regex}, replacement::String)

Replace all occurrences of `pattern` in `column` with `replacement`. If the pattern is a string, 
this function replaces exact matches. If the pattern is a regex, this function replaces regex matches.

# Arguments
- `column::String`: the string in which to replace.
- `pattern::Union{String, Regex}`: the pattern to replace.
- `replacement::String`: the string to replace the pattern with.

# Returns
- `String`: the updated string with all instances of the pattern replaced.

# Examples
```julia
str_replace_all("hello world world", "world", "there") # returns "hello there there"
str_replace_all("hello world world", r"world", "there") # returns "hello world there"

"""
function str_replace_all(column::Union{Missing, String}, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        for p in patterns
            column = replace(column, strip(p) * r"\b" => replacement)
        end
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern * r"\b" => replacement)
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end

""" 
`str_remove`

    str_remove(column::String, pattern::Union{String, Regex})

Remove the first occurrence of `pattern` from `column`. If the pattern is a string, this function
removes exact matches. If the pattern is a regex, this function removes regex matches.

# Arguments
- `column::String`: the string from which to remove.
- `pattern::Union{String, Regex}`: the pattern to remove.

# Returns
- `String`: the updated string with the first instance of the pattern removed.

# Examples
```julia
str_remove("hello world", "hello") # returns " world"
str_remove("hello world", r"^hello") # returns " world"
"""
function str_remove(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        first_occurrences = [(p, findfirst(p, column)) for p in patterns]
        # Filter out patterns that were not found
        found_occurrences = filter(x -> x[2] !== nothing, first_occurrences)
        # If none of the patterns are found, return the original column
        if isempty(found_occurrences)
            return column
        end
        # Get the first pattern among the found patterns
        first_pattern = sort(found_occurrences, by = x -> x[2].start)[1][1]
        # Remove the first occurrence of the first found pattern
        column = replace(column, first_pattern * r"\b" => "", count = 1)
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern * r"\b" => "", count = 1) # Only remove the first occurrence
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end
"""
`str_remove_all`

    str_remove_all(column::String, pattern::Union{String, Regex})

Remove all occurrences of `pattern` from `column`. If the pattern is a string, this function
removes exact matches. If the pattern is a regex, this function removes regex matches.

# Arguments
- `column::String`: the string from which to remove.
- `pattern::Union{String, Regex}`: the pattern to remove.

# Returns
- `String`: the updated string with all instances of the pattern removed.

# Examples
```julia
str_remove_all("hello world hello", "hello") # returns " world "
str_remove_all("hello world hello", r"hello") # returns " world "
"""
function str_remove_all(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        for p in patterns
            column = replace(column, strip(p) * r"\b" => "")
        end
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern * r"\b" => "")
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end
"""
`str_count`

    str_count(column::String, pattern::Union{String, Regex})

Count the number of occurrences of `pattern` in `column`. If the pattern is a string, this function
counts exact matches. If the pattern is a regex, this function counts regex matches.

# Arguments
- `column::String`: the string in which to count.
- `pattern::Union{String, Regex}`: the pattern to count.

# Returns
- `Int`: the number of instances of the pattern in the string.

# Examples
```julia
str_count("hello world hello", "hello") # returns 2
str_count("hello world hello", r"hello") # returns 2

"""

function str_count(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 
    
    if pattern isa String
        return count(occursin(pattern), split(column))
    else
        # For regular expressions, count the number of matches
        return length(collect(eachmatch(pattern, column)))
    end
end
"""
`str_squish`

    str_squish(column::String)

Remove leading, trailing, and consecutive whitespace from `column`.

# Arguments
- `column::String`: the string to squish.

# Returns
- `String`: the squished string.

# Examples
```julia
str_squish("  hello  world  ") # returns "hello world"
"""

function str_squish(column::Union{Missing, String})
    if ismissing(column)
        return(column)
    end
    # Remove leading and trailing white spaces
    squished = strip(column)
    # Replace any sequence of whitespace characters with a single space
    return replace(squished, r"\s+" => s" ")
end


"""
`str_equal`

    str_equal(column1::String, column2::String)

Check if `column1` is exactly equal to `column2`.

# Arguments
- `column1::String`: the first string to compare.
- `column2::String`: the second string to compare.

# Returns
- `Bool`: `true` if the strings are equal, `false` otherwise.

# Examples
```julia
str_equal("hello world", "hello world") # returns true
str_equal("Hello world", "hello world") # returns false
"""

function str_equal(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 
    
    if pattern isa String
        return column == pattern
    else
        # For regular expressions, directly use match
        return !isempty(match(pattern, column))
    end
end

"""
`str_to_upper`

    str_to_upper(column::String)

Convert all characters in `column` to uppercase.

# Arguments
- `column::String`: the string to convert.

# Returns
- `String`: the string converted to uppercase.

# Examples
```julia
str_to_upper("hello world") # returns "HELLO WORLD"
"""

function str_to_upper(s::Union{String, Missing})
    if ismissing(s)
        return(s)
    else
        return uppercase(s)
    end
end

"""
`str_to_lower`

    str_to_lower(column::String)

Convert all characters in `column` to lowercase.

# Arguments
- `column::String`: the string to convert.

# Returns
- `String`: the string converted to lowercase.

# Examples
```julia
str_to_lower("HELLO WORLD") # returns "hello world"
"""

function str_to_lower(s::Union{String, Missing})
    if ismissing(s)
        return(s)
    else
        return lowercase(s)
    end
end
"""
`str_split`

    str_split(column::String, delimiter::String, limit::Int=-1)

Split `column` into substrings using `delimiter` as the delimiter string. 
If `limit` is provided and positive, the returned array will contain a maximum of `limit` elements 
with the last element containing the rest of `string`.

# Arguments
- `column::String`: the string to split.
- `delimiter::String`: the delimiter to use.
- `limit::Int=-1`: the maximum number of split elements.

# Returns
- `Array{SubString{String},1}`: an array of substrings.

# Examples
```julia
str_split("hello world", " ") # returns ["hello", "world"]
str_split("hello world", " ", 1) # returns ["hello"]
"""

function str_split(column::Union{Missing, String}, pattern::Union{String, Regex}, n::Int=2)
    if ismissing(column)
        return(column)
    end
    split_parts = split(column, pattern)
    return split_parts[1:min(end, n)]
end

"""
`str_subset`

    str_subset(column::String, pattern::Union{String, Regex})

Return the substrings of `column` that match `pattern`. If the pattern is a string, 
this function matches exact matches. If the pattern is a regex, this function matches regex matches.

# Arguments
- `column::String`: the string to search within.
- `pattern::Union{String, Regex}`: the pattern to search for.

# Returns
- `Array{SubString{String},1}`: an array of matched substrings.

# Examples
```julia
str_subset("hello world", "hello") # returns ["hello"]
str_subset("hello world", r"\w+") # returns ["hello", "world"]
"""

function str_subset(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 
    
    
    if pattern isa String
        or_groups = split(pattern, '|')

        or_results = []
        for or_group in or_groups
            trimmed_pattern = strip(or_group)
            push!(or_results, occursin(trimmed_pattern, column))
        end

        return any(or_results)
    else
        # For regular expressions, directly use occursin
        return occursin(pattern, column)
    end
end


end 
