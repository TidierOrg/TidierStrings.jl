export str_detect, str_replace, str_replace_all, str_removal_all, str_remove, str_count, str_squish, str_equal, str_to_upper, str_to_lower, str_split, str_subset



"""
$docstring_str_detect
"""

function str_detect(column::String, pattern::Union{String, Regex})
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
$docstring_str_replace
"""

function str_replace(column::String, pattern::Union{String, Regex}, replacement::String)
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
$docstring_str_replace_all
"""


function str_replace_all(column::String, pattern::Union{String, Regex}, replacement::String)
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
$docstring_str_remove
"""

function str_remove(column::String, pattern::Union{String, Regex})
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
$docstring_str_remove_all
"""

function str_remove_all(column::String, pattern::Union{String, Regex})
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
$docstring_str_count
"""

# counts the number of matches in a string
# Using collect() to transform the entire iterator into an array could potentially use a lot of 
#memory if there are a large number of matches, so use this with caution when working with large data.
# str_count inside @mutate string be exact match. wont catch 0 in 2018 for example. or 2018 in 2018-22

function str_count(column::String, pattern::Union{String, Regex})
    if pattern isa String
        return count(occursin(pattern), split(column))
    else
        # For regular expressions, count the number of matches
        return length(collect(eachmatch(pattern, column)))
    end
end



"""
$docstring_str_squish
"""


function str_squish(column::String)
    # Remove leading and trailing white spaces
    squished = strip(column)
    # Replace any sequence of whitespace characters with a single space
    return replace(squished, r"\s+" => s" ")
end

"""
$docstring_str_equal
"""


function str_equal(column::String, pattern::Union{String, Regex})
    if pattern isa String
        return column == pattern
    else
        # For regular expressions, directly use match
        return !isempty(match(pattern, column))
    end
end

"""
$docstring_str_to_lower
"""

function str_to_lower(s)
    return lowercase(s)
end

"""
$docstring_str_to_upper
"""

function str_to_upper(s)
    return uppercase(s)
end

### two bonuses.. not totally sure what these ones are used for.
"""
$docstring_str_split
"""

function str_split(column::String, pattern::Union{String, Regex}, n::Int=2)
    split_parts = split(column, pattern)
    return split_parts[1:min(end, n)]
end


"""
$docstring_str_subset
"""

# I dont fully understand why you would use this over str_detect, or how to tease out and test functiality differences

function str_subset(column::String, pattern::Union{String, Regex})
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

