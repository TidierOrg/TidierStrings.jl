"""
$docstring_str_c
"""
function str_c(strings::AbstractVector; sep::AbstractString="")
    strings = filter(!ismissing, strings)

    return join(strings, sep)
end

"""
$docstring_str_flatten
"""
function str_flatten(string::AbstractVector, collapse::AbstractString="", last::Union{Nothing,AbstractString}=nothing; missing_rm::Bool=false)
    if missing_rm
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
function str_flatten_comma(string::AbstractVector, last::Union{Nothing,AbstractString}=nothing; missing_rm::Bool=false)
    return str_flatten(string, ", ", last, missing_rm=missing_rm)
end