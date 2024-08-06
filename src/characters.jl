"""
$docstring_str_dup
"""
function str_dup(s::AbstractString, times::Integer)
    if ismissing(s)
        return (s)
    end

    return repeat(s, times)
end

"""
$docstring_str_length
"""
function str_length(s::AbstractString)
    if ismissing(s)
        return (s)
    end

    return length(s)
end

"""
$docstring_str_width
"""
function str_width(s::AbstractString)
    if ismissing(s)
        return (s)
    end

    return textwidth(s)
end

"""
$docstring_str_trim
"""
function str_trim(s::AbstractString, side::String="both")
    if ismissing(s)
        return (s)
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
$docstring_str_squish
"""
function str_squish(column)
    if ismissing(column)
        return (column)
    end
    # Remove leading and trailing white spaces
    squished = strip(column)
    # Replace any sequence of whitespace characters with a single space
    return replace(squished, r"\s+" => s" ")
end