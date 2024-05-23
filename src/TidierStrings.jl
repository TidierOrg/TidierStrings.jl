module TidierStrings

using StringEncodings

export str_detect, str_replace, str_replace_all, str_remove_all, str_remove, str_count, str_squish, str_equal, str_to_upper, str_to_lower, str_split, str_subset, 
       str_to_title, str_to_sentence, str_dup, str_length, str_width, str_trim, str_unique, word, str_starts, str_ends, str_which, str_flatten, str_flatten_comma,
       str_locate, str_locate_all, str_conv, str_replace_missing, str_like

include("strings_docstrings.jl")

"""
$docstring_str_detect
"""
function str_detect(column, pattern::Union{String, Regex})
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
$docstring_str_locate
"""
function str_locate(string::AbstractString, pattern::Union{AbstractString,Regex})
    if isa(pattern, Regex)
        regex_pattern = pattern
    else
        regex_pattern = Regex(pattern)
    end
    # todo
end

"""
$docstring_str_locate_all
"""
function str_locate_all(string::AbstractString, pattern::Union{AbstractString,Regex})
    if isa(pattern, Regex)
        regex_pattern = pattern
    else
        regex_pattern = Regex(pattern)
    end
    # todo
end

"""
$docstring_str_flatten
"""
function str_flatten(string::AbstractVector, collapse::AbstractString="", last::Union{Nothing,AbstractString}=nothing; na_rm::Bool=false)
    if na_rm
        string = filter(!ismissing, string)
    end

    if isempty(string)
        return ""
    elseif length(string) == 1
        return string[1]
    else
        if isnothing(last)
            return join(string, collapse)
        else
            if length(string) == 2
                return join(string, last)
            else
                return join(string[1:end-1], collapse) * last * string[end]
            end
        end
    end
end

"""
$docstring_str_flatten_comma
"""
function str_flatten_comma(string::AbstractVector, last::Union{Nothing,AbstractString}=nothing; na_rm::Bool=false)
    return str_flatten(string, ", ", last, na_rm=na_rm)
end

"""
$docstring_str_conv
"""
function str_conv(string::Union{String,Vector{UInt8}}, encoding::String)
    encoder = StringEncodings.Encoding(encoding)
    if isa(string, Vector{UInt8})
        return StringEncodings.decode(string, encoder)
    else
        byte_array = StringEncodings.encode(string, encoder)
        return StringEncodings.decode(byte_array, encoder)
    end
end

"""
$docstring_str_replace_missing
"""
function str_replace_missing(string::AbstractVector{Union{Missing,String}}, replacement::String="missing")
    return [ismissing(s) ? replacement : s for s in string]
end

"""
$docstring_str_like
"""
function str_like(string::AbstractVector{String}, pattern::String; ignore_case::Bool = true)
    # Convert SQL LIKE pattern to Julia regex pattern
    julia_pattern = replace(pattern, r"[%_]" => s -> s == "%" ? ".*" : ".")
    julia_pattern = replace(julia_pattern, r"(\\%)" => "%")
    julia_pattern = replace(julia_pattern, r"(\\_)" => "_")

    # Create a regular expression object
    regex_flags = ignore_case ? "i" : ""
    regex_pattern = Regex("^" * julia_pattern * "\$", regex_flags)

    # Apply the pattern to each string in the input vector
    return [occursin(regex_pattern, str) for str in string]
end

"""
$docstring_str_starts
"""
function str_starts(string::Vector{T}, pattern::Union{AbstractString,Regex}; negate::Bool=false)::Vector{Bool} where {T}
    if pattern isa Regex
        matches = [match(pattern, s) !== nothing for s in string]
        return negate ? .!matches : matches
    elseif pattern isa AbstractString
        matches = [startswith(s, pattern) for s in string]
        return negate ? .!matches : matches
    else
        error("Pattern must be either a Regex or an AbstractString.")
    end
end

"""
$docstring_str_ends
"""
function str_ends(string::Vector{T}, pattern::Union{AbstractString,Regex}; negate::Bool=false)::Vector{Bool} where {T}
    if pattern isa Regex
        matches = [match(pattern, s) !== nothing for s in string]
        return negate ? .!matches : matches
    elseif pattern isa AbstractString
        matches = [endswith(s, pattern) for s in string]
        return negate ? .!matches : matches
    else
        error("Pattern must be either a Regex or an AbstractString.")
    end
end

"""
$docstring_str_which
"""
function str_which(strings::Vector{T}, pattern::Union{AbstractString, Regex}; negate::Bool=false)::Vector{Int} where {T}
    indices = Int[]
    for (i, s) in enumerate(strings)
        if pattern isa Regex && occursin(pattern, s)
            push!(indices, i)
        elseif pattern isa AbstractString && !ismissing(s) && occursin(pattern, s)
            push!(indices, i)
        end
    end

    if negate
        return setdiff(1:length(strings), indices)
    else
        return indices
    end
end

"""
$docstring_str_replace
"""
function str_replace(column, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        first_occurrences = [(p, findfirst(Regex(p), column)) for p in patterns]
        # Filter out patterns that were not found
        found_occurrences = filter(x -> x[2] !== nothing, first_occurrences)
        # If none of the patterns are found, return the original column
        if isempty(found_occurrences)
            return column
        end
        # Get the first pattern among the found patterns
        first_pattern = sort(found_occurrences, by = x -> x[2].start)[1][1]
        # Replace the first occurrence of the first found pattern
        column = replace(column, Regex(first_pattern) => replacement, count = 1)
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
function str_replace_all(column, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        for p in patterns
            # Convert the pattern to a Regex object
            regex = Regex(strip(p))
            column = replace(column, regex => replacement)
        end
    else
        # For regular expressions, directly use replace
        regex = Regex(pattern.pattern)
        column = replace(column, regex => replacement)
    end
    # Replace multiple consecutive spaces with a single space
    column = replace(column, r"\s+" => " ")
    return column
end



"""
$docstring_str_remove
"""
function str_remove(column, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        first_occurrences = [(p, findfirst(Regex(p), column)) for p in patterns]
        # Filter out patterns that were not found
        found_occurrences = filter(x -> x[2] !== nothing, first_occurrences)
        # If none of the patterns are found, return the original column
        if isempty(found_occurrences)
            return column
        end
        # Get the first pattern among the found patterns
        first_pattern = sort(found_occurrences, by = x -> x[2].start)[1][1]
        # Remove the first occurrence of the first found pattern
        column = replace(column, Regex(first_pattern) => "", count = 1)
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
function str_remove_all(column, pattern::Union{String, Regex})
    if ismissing(column)
        return(column)
    end 

    if pattern isa String
        patterns = split(pattern, '|')
        for p in patterns
            column = replace(column, Regex(strip(p)) => "")
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
function str_count(column, pattern::Union{String, Regex})
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
function str_squish(column)
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
function str_equal(column, pattern::Union{String, Regex})
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
function str_to_upper(s)
    if ismissing(s)
        return(s)
    else
        return uppercase(s)
    end
end


"""
$docstring_str_to_lower
"""
function str_to_lower(s)
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
$docstring_str_to_title
"""
function str_to_title(s::AbstractString)
    if ismissing(s)
        return(s)
    else
        return titlecase(s)
    end
end


"""
$docstring_str_to_sentence
"""
function str_to_sentence(s::AbstractString)
    if ismissing(s)
        return(s)
    else
        sentences = split(s, r"(?<=[.!?])\s+")
        capitalized_sentences = [uppercase(first(sentence)) * lowercase(sentence[2:end]) for sentence in sentences]
        return join(capitalized_sentences, " ")
    end
end


"""
$docstring_str_dup
"""
function str_dup(s::AbstractString, times::Integer)
    if ismissing(s)
        return(s)
    end

    return repeat(s, times)
end


"""
$docstring_str_length
"""
function str_length(s::AbstractString)
    if ismissing(s)
        return(s)
    end

    return length(s)
end


"""
$docstring_str_width
"""
function str_width(s::AbstractString)
    if ismissing(s)
        return(s)
    end

    return textwidth(s)
end


"""
$docstring_str_trim
"""
function str_trim(s::AbstractString, side::String="both")
    if ismissing(s)
        return(s)
    end

    if side == "both"
        return strip(s)
    elseif side == "left"
        return lstrip(s)
    elseif side == "right"
        return rstrip(s)
    else
        throw(ArgumentError("side must be one of 'both', 'left', or 'right'"))
    end
end

"""
$docstring_str_unique
"""
function str_unique(strings::AbstractVector{<:AbstractString}; ignore_case::Bool=false)
    if ismissing(strings)
        return(strings)
    end

    unique_strings = unique(strings)
    if ignore_case
        unique_strings = [unique_strings[findfirst(x -> lowercase(x) == lowercase(unique_string), strings)] for unique_string in unique_strings]
    end
    return unique_strings
end

"""
$docstring_word
"""
function word(string::AbstractString, start_index::Int=1, end_index::Int=start_index, sep::AbstractString=" ")
    if ismissing(string)
        return(string)
    end

    words = split(string, sep)

    if start_index < 0
        start_index = length(words) + start_index + 1
    end

    if end_index < 0
        end_index = length(words) + end_index + 1
    end

    return words[start_index:end_index]
end

"""
$docstring_str_subset
"""
function str_subset(column, pattern::Union{String, Regex})
    processor = x -> begin
        if ismissing(x)
            return x
        end

        matched = false

        if pattern isa String
            or_groups = split(pattern, '|')
            for or_group in or_groups
                trimmed_pattern = strip(or_group)
                if occursin(trimmed_pattern, x)
                    matched = true
                    break
                end
            end
        else
            matched = occursin(pattern, x)
        end

        return matched ? x : ""
    end

    return column isa Vector{String} ? map(processor, column) : processor(column)
end


end 
