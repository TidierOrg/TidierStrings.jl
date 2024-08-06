module TidierStrings

using StringEncodings

export
    # matching
    str_count, str_detect, str_locate, str_locate_all, str_replace, str_replace_all,
    str_remove, str_remove_all, str_split, str_starts, str_ends, str_subset, str_which,
    # concatenation
    str_c, str_flatten, str_flatten_comma,
    # characters
    str_dup, str_length, str_width, str_trim, str_squish, str_wrap,
    # locale
    str_equal, str_to_upper, str_to_lower, str_to_title, str_to_sentence, str_unique,
    # other
    str_conv, str_like, str_replace_missing, word

include("docstrings.jl")
include("matching.jl")
include("concatenation.jl")
include("characters.jl")
include("locale.jl")
include("other.jl")

end