module TidierStrings
export str_detect, str_replace, str_replace_all, str_remove_all, str_remove, str_count, str_squish, str_equal, str_to_upper, str_to_lower, str_split, str_subset


include("strings_docstrings.jl")


"""
$docstring_str_detect
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
$docstring_str_replace
"""
function str_replace(column::Union{Missing, String}, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        first_occurrences = [(p, findfirst(Regex(p * "\\b"), column)) for p in patterns]
        # Filter out patterns that were not found
        found_occurrences = filter(x -> x[2] !== nothing, first_occurrences)
        # If none of the patterns are found, return the original column
        if isempty(found_occurrences)
            return column
        end
        # Get the first pattern among the found patterns
        first_pattern = sort(found_occurrences, by = x -> x[2].start)[1][1]
        # Replace the first occurrence of the first found pattern
        column = replace(column, Regex(first_pattern * "\\b") => replacement, count = 1)
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern => replacement, count = 1) # Only replace the first occurrence
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end




"""
$docstring_str_replace_all
"""
function str_replace_all(column::Union{Missing, String}, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        for p in patterns
            # Convert the pattern to a Regex object
            regex = Regex(strip(p) * "\\b")
            column = replace(column, regex => replacement)
        end
    else
        # For regular expressions, directly use replace
        regex = Regex(pattern.pattern * "\\b")
        column = replace(column, regex => replacement)
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end



"""
$docstring_str_remove
"""
function str_remove(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        first_occurrences = [(p, findfirst(Regex(p * "\\b"), column)) for p in patterns]
        # Filter out patterns that were not found
        found_occurrences = filter(x -> x[2] !== nothing, first_occurrences)
        # If none of the patterns are found, return the original column
        if isempty(found_occurrences)
            return column
        end
        # Get the first pattern among the found patterns
        first_pattern = sort(found_occurrences, by = x -> x[2].start)[1][1]
        # Remove the first occurrence of the first found pattern
        column = replace(column, Regex(first_pattern * "\\b") => "", count = 1)
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern => "", count = 1) # Only remove the first occurrence
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end


"""
$docstring_str_remove_all
"""
function str_remove_all(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        for p in patterns
            column = replace(column, Regex(strip(p) * "\\b") => "")
        end
    else
        # For regular expressions, directly use replace
        column = replace(column, pattern => "")
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end



"""
$docstring_str_count
"""
function str_count(column::Union{Missing, String}, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        pattern = Regex(pattern) # treat pattern as regular expression
    end
    
    # Count the number of matches for the regular expression
    return length(collect(eachmatch(pattern, column)))
end




"""
$docstring_str_squish
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
$docstring_str_equal
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
$docstring_str_to_upper
"""
function str_to_upper(s::Union{String, Missing})
    if ismissing(s)
        return(s)
    else
        return uppercase(s)
    end
end


"""
$docstring_str_to_lower
"""
function str_to_lower(s::Union{String, Missing})
    if ismissing(s)
        return(s)
    else
        return lowercase(s)
    end
end


#"""
#$docstring_str_split
#"""
#function str_split(column::Union{Missing, String}, pattern::Union{String, Regex}, n::Int=2)
#    if ismissing(column)
#        return(column)
#    end
#    split_parts = split(column, pattern)
#    return split_parts[1:min(end, n)]
#end



"""
$docstring_str_subset
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
