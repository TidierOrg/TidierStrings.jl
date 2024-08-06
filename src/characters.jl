"""
$docstring_str_dup
"""
function str_dup(s::AbstractString, times::Integer)
    return repeat(s, times)
end

"""
$docstring_str_length
"""
function str_length(s::AbstractString)
    return length(s)
end

"""
$docstring_str_width
"""
function str_width(s::AbstractString)::Integer
    return Base.textwidth(s)
end

"""
$docstring_str_trim
"""
function str_trim(s::AbstractString, side::String="both")::String
    if side == "both"
        return Base.strip(s)
    elseif side == "left"
        return Base.lstrip(s)
    elseif side == "right"
        return Base.rstrip(s)
    else
        throw(ArgumentError("side must be one of 'both', 'left', or 'right'"))
    end
end

"""
$docstring_str_squish
"""
function str_squish(column)::String
    squished::String = Base.strip(column)

    return Base.replace(squished, r"\s+" => Base.s" ")
end

"""
$docstring_str_wrap
"""
function str_wrap(
    string::AbstractString;
    width::Integer=80,
    indent::Integer=0,
    exdent::Integer=0,
    whitespace_only::Bool=true)::String

    width::Integer = Base.max(width, 1)

    split_pattern::Regex = r"\s+"
    if whitespace_only
        split_pattern = r"\s+"
    else
        split_pattern = r"\W+"
    end

    words::Vector{SubString{String}} = Base.split(string, split_pattern)

    indent_str::String = " "^indent
    exdent_str::String = " "^exdent

    lines::Vector{String} = []
    current_line::String = indent_str

    for word in words
        if Base.length(current_line) + Base.length(word) + 1 > width
            Base.push!(lines, current_line)
            current_line = exdent_str * word
        else
            if current_line == indent_str
                current_line *= word
            else
                current_line *= " " * word
            end
        end
    end

    Base.push!(lines, current_line)

    return Base.join(lines, "\n")
end