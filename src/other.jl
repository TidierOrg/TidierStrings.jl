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
function str_like(string::AbstractVector{String}, pattern::String; ignore_case::Bool=true)
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