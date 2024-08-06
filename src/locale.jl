"""
$docstring_str_equal
"""
function str_equal(column, pattern::Union{String,Regex})
    if ismissing(column)
        return (column)
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
        return (s)
    else
        return uppercase(s)
    end
end

"""
$docstring_str_to_lower
"""
function str_to_lower(s)
    if ismissing(s)
        return (s)
    else
        return lowercase(s)
    end
end

"""
$docstring_str_to_title
"""
function str_to_title(s::AbstractString)
    if ismissing(s)
        return (s)
    else
        return titlecase(s)
    end
end

"""
$docstring_str_to_sentence
"""
function str_to_sentence(s::AbstractString)
    if ismissing(s)
        return (s)
    else
        sentences = split(s, r"(?<=[.!?])\s+")
        capitalized_sentences = [uppercase(first(sentence)) * lowercase(sentence[2:end]) for sentence in sentences]
        return join(capitalized_sentences, " ")
    end
end

"""
$docstring_str_unique
"""
function str_unique(strings::AbstractVector{<:AbstractString}; ignore_case::Bool=false)
    if ismissing(strings)
        return (strings)
    end

    unique_strings = unique(strings)
    if ignore_case
        unique_strings = [unique_strings[findfirst(x -> lowercase(x) == lowercase(unique_string), strings)] for unique_string in unique_strings]
    end
    return unique_strings
end