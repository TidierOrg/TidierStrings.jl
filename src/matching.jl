"""
$docstring_str_count
"""
function str_count(column, pattern::Union{String, Regex}; overlap::Bool=false)
    if ismissing(column)
        return column
    end

    if pattern isa Regex
        return length(collect(eachmatch(pattern, column; overlap=overlap)))
    else
        total = 0
        for p in split(pattern, '|')
            pos = firstindex(column)
            plen = lastindex(p) - firstindex(p) + 1
            while true
                idx = findnext(p, column, pos)
                idx === nothing && break
                total += 1
                start = idx isa UnitRange ? first(idx) : idx
                pos = overlap ? start + 1 : start + plen
            end
        end
        return total
    end
end



"""
$docstring_str_detect
"""
function str_detect(column, pattern::Union{String,Regex})
    if ismissing(column)
        return (column)
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

    match = Base.match(regex_pattern, string)

    if match === nothing
        return (NaN, NaN)
    else
        return (first(match.offset), last(match.offset))
    end
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

    matches = collect(eachmatch(regex_pattern, string))

    return [(first(m.offset), last(m.offset)) for m in matches]
end

"""
$docstring_str_replace
"""
function str_replace(column, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return column
    end

    if pattern isa String
        # split on '|' and find which literal subpattern occurs first
        earliest_pat = nothing
        earliest_pos = typemax(Int)
        for p in split(pattern, '|')
            idx = findfirst(p, column)
            if idx !== nothing
                pos = idx isa UnitRange ? first(idx) : idx
                if pos < earliest_pos
                    earliest_pos = pos
                    earliest_pat = p
                end
            end
        end
        result = earliest_pat === nothing ? column :
                 replace(column, earliest_pat => replacement, count=1)
    else
        result = replace(column, pattern => replacement, count=1)
    end

    return replace(result, r"\s+" => " ")
end




"""
$docstring_str_replace_all
"""
function str_replace_all(column, pattern::Union{String, Regex}, replacement::String)
    if ismissing(column)
        return column
    end

    if pattern isa String
        result = column
        for p in split(pattern, '|')
            result = replace(result, p => replacement)
        end
    else
        result = replace(column, pattern => replacement)
    end

    return replace(result, r"\s+" => " ")
end




"""
$docstring_str_remove
"""
function str_remove(column, pattern::Union{String, Regex})
    if ismissing(column)
        return column
    end

    result = if pattern isa String
        earliest_pat = nothing
        earliest_pos = typemax(Int)
        for p in split(pattern, '|')
            idx = findfirst(p, column)
            if idx !== nothing
                pos = idx isa UnitRange ? first(idx) : idx
                if pos < earliest_pos
                    earliest_pos = pos
                    earliest_pat = p
                end
            end
        end
        earliest_pat === nothing ? column : replace(column, earliest_pat => "", count=1)
    else
        replace(column, pattern => "", count=1)
    end

    return replace(result, r"\s+" => " ")
end



"""
$docstring_str_remove_all
"""
function str_remove_all(column, pattern::Union{String, Regex})
    if ismissing(column)
        return column
    end

    if pattern isa String
        patterns = (split(pattern, '|'))
        for p in patterns
            column = replace(column, p => "")
        end
    else
        column = replace(column, pattern => "")
    end

    # collapse multiple spaces into one
    #column = replace(column, r"\s+" => " ")
    return column
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
$docstring_str_starts
"""
function str_starts(string::AbstractString, pattern::Union{AbstractString,Regex}; negate::Bool=false)::Bool
    if ismissing(string)
        return (string)
    end
    if pattern isa Regex
        match_result = match(pattern, string) !== nothing
    elseif pattern isa AbstractString
        match_result = startswith(string, pattern)
    else
        error("Pattern must be either a Regex or an AbstractString.")
    end

    return negate ? !match_result : match_result
end
"""
$docstring_str_ends
"""
function str_ends(string::AbstractString, pattern::Union{AbstractString,Regex}; negate::Bool=false)::Bool
    if ismissing(string)
        return (string)
    end
    if pattern isa Regex
        match_result = match(pattern, string) !== nothing
    elseif pattern isa AbstractString
        match_result = endswith(string, pattern)
    else
        error("Pattern must be either a Regex or an AbstractString.")
    end

    return negate ? !match_result : match_result
end


"""
$docstring_str_subset
"""
function str_subset(column, pattern::Union{String,Regex})
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

"""
$docstring_str_which
"""
function str_which(strings::Vector{T}, pattern::Union{AbstractString,Regex}; negate::Bool=false)::Vector{Int} where {T}
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
$docstring_str_extract
"""
function str_extract(input::AbstractString, pattern::Union{String, Regex})
    if pattern isa String
        idx = findfirst(pattern, input)
        return idx === nothing ? missing : input[idx]
    else
        m = match(pattern, input)
        return m === nothing ? missing : m.match
    end
end

"""
$docstring_str_extract_all
"""
function str_extract_all(string::AbstractString, pattern::Union{String, Regex}; captures::Bool=false)
    if ismissing(string)
        return missing
    end

    if pattern isa String
        patterns = split(pattern, '|')
        recs = Tuple{Int,String}[]
        for p in patterns
            plen = length(p)
            startpos = 1
            while true
                idx = findnext(p, string, startpos)
                idx === nothing && break
                pos = idx isa UnitRange ? first(idx) : idx
                push!(recs, (pos, String(string[pos:pos+plen-1])))
                startpos = pos + plen
            end
        end
        isempty(recs) && return missing
        sort!(recs, by = x -> x[1])
        return [match for (_, match) in recs]
    else
        if captures
            to_missing(l) = [ifelse(isnothing(c), missing, c) for c in l]
            matches = [to_missing(m.captures) for m in eachmatch(pattern, string)]
        else
            matches = [String(m.match) for m in eachmatch(pattern, string)]
        end
        return isempty(matches) ? missing : matches
    end
end



