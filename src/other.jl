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
$docstring_str_like
"""
function str_like(string::AbstractString, pattern::String; ignore_case::Bool=true)
    # Convert SQL LIKE pattern to Julia regex pattern
    julia_pattern = replace(pattern, r"[%_]" => s -> s == "%" ? ".*" : ".")
    julia_pattern = replace(julia_pattern, r"(\\%)" => "%")
    julia_pattern = replace(julia_pattern, r"(\\_)" => "_")

    # Create a regular expression object
    regex_flags = ignore_case ? "i" : ""
    regex_pattern = Regex("^" * julia_pattern * "\$", regex_flags)

    # Apply the pattern to the input string
    return occursin(regex_pattern, string)
end

"""
$docstring_str_replace_missing
"""
function str_replace_missing(string::AbstractVector{Union{Missing,String}}, replacement::String="missing")
    return [ismissing(s) ? replacement : s for s in string]
end

"""
$docstring_word
"""
function word(string::AbstractString, start_index::Int=1, end_index::Int=start_index, sep::AbstractString=" ")
    if ismissing(string)
        return (string)
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
$docstring_str_trunc
"""
function str_trunc(string::AbstractString, width::Int; side::String = "right", ellipsis::AbstractString = "...")
    # Handle cases where truncation is not needed
    if length(string) <= width
        return string
    end
    
    # Adjust width to account for ellipsis
    adjusted_width = max(width - length(ellipsis), 0)
    
    truncated_string = ""
    
    # Truncate based on the side argument
    if side == "right"
        truncated_string = string[1:adjusted_width] * ellipsis
    elseif side == "left"
        truncated_string = ellipsis * string[end-adjusted_width:end]
    elseif side == "center"
        half_width = div(adjusted_width, 2)
        truncated_string = string[1:half_width] * ellipsis * string[end-half_width:end]
    else
        throw(ArgumentError("Invalid value for side. Must be :right, :left, or :center."))
    end
    
    return truncated_string
end
