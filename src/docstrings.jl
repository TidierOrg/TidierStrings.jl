const docstring_str_detect  =
"""
    str_detect(column::String, pattern::Union{String, Regex})

Determine if a string contains a certain pattern.

# Arguments
- `column`: The string to check.
pattern: A string or a regular expression to find within the string.
The pattern can include special logic:

Use | to represent "or" (e.g., "red|blue" matches any string that contains "red" or "blue").
Use & to represent "and" (e.g., "red&blue" matches any string that contains both "red" and "blue").
Returns
true if the string contains the pattern, false otherwise.
# Examples
```jldoctest
julia> str_detect("The sky is blue", "blue")
true

julia> str_detect("The sky is blue", "red")
false

julia> str_detect("The sky is blue", r"\bblu\b")
false

julia> str_detect("The sky is blue", "blue|red")
true

julia> str_detect("The sky is blue and the sun is red", "blue&red")
true
```
"""

const docstring_str_flatten  =
"""
    str_flatten(string::AbstractVector, collapse::AbstractString="", last::Union{Nothing,AbstractString}=nothing; missing_rm::Bool=false)

Flatten a string vector into a single string.

Arguments
- `string`: Input string.
- `collapse`: The string to insert between each string in the input vector. Default is `""`.
- `last`: The string to insert at the end of the flattened string. Default is `nothing`.
- `missing_rm`: Remove `Missing` values from the input vector. Default is `false`.

Returns
A flattened string.

Examples
```jldoctest
julia> str_flatten(["a", "b", "c"])
"abc"

julia> str_flatten(["a", "b", "c", "d"])
"abcd"

julia> str_flatten(['a', 'b', 'c'], "-")
"a-b-c"

julia> str_flatten(['a', 'b', 'c'], ", ")
"a, b, c"

julia> str_flatten(['a', 'b', 'c'], ", ", " and ")
"a, b and c"
```
"""

const docstring_str_flatten_comma  =
"""
    str_flatten_comma(string::AbstractVector, last::Union{Nothing,AbstractString}=nothing; missing_rm::Bool=false)

Flatten a string vector into a single string, separated by commas.

Arguments
- `string`: Input string.
- `last`: The string to insert at the end of the flattened string. Default is `nothing`.
- `missing_rm`: Remove `Missing` values from the input vector. Default is `false`.

Returns
A flattened string.

Examples
```jldoctest
julia> str_flatten_comma(['a', 'b', 'c'])
"a, b, c"

julia> str_flatten_comma(['a', 'b'])
"a, b"

julia> str_flatten_comma(['a', 'b'], " and ")
"a and b"
```
"""

const docstring_str_replace  =
"""
    str_replace(column::String, pattern::Union{String, Regex}, replacement::String)

Replace the first occurrence of a pattern in a string with a specified string.

Arguments
column: The string in which to replace the pattern.
pattern: A string or a regular expression to find within the string.
replacement: The string to insert in place of the pattern.
The pattern can include special logic:

Use | to represent "or" (e.g., "red|blue" matches any string that contains "red" or "blue").
Returns
A new string with the first occurrence of the pattern replaced with the replacement.
Examples
```jldoctest
julia> str_replace("The sky is blue", "blue", "red")
"The sky is red"

julia> str_replace("The sky is blue", r"\bblu\b", "red")
"The sky is blue"

julia> str_replace("The sky is blue", "blue|sky", "red")
"The red is blue"
```
"""

const docstring_str_replace_all =
"""
    str_replace_all(column::String, pattern::Union{String, Regex}, replacement::String)

Replace all occurrences of a pattern in a string with a specified string.

# Arguments
- `column`: The string in which to replace the pattern.
- `pattern`: A string or a regular expression to find within the string.
replacement: The string to insert in place of the pattern.
The pattern can include special logic:

Use | to represent "or" (e.g., "red|blue" matches any string that contains "red" or "blue").
Returns
A new string with all occurrences of the pattern replaced with the replacement.
# Examples
```jldoctest
julia> str_replace_all("The blue sky is blue", "blue", "red")
"The red sky is red"

julia> str_replace_all("The blue sky is blue", r"\bblu\b", "red")
"The blue sky is blue"

julia> str_replace_all("The blue sky is blue", "blue|sky", "red")
"The red red is red"
```
"""
const docstring_str_count =
"""
    str_count(column::String, pattern::Union{String, Regex})

Count the number of non-overlapping occurrences of a pattern in a string.

# Arguments
- `column`: The string in which to count the pattern.
- `pattern`: A string or a regular expression to find within the string.
The pattern can include special logic:

Use | to represent "or" (e.g., "red|blue" counts any string that contains "red" or "blue").
Returns
The count of non-overlapping occurrences of pattern in column.
Examples
```jldoctest
julia> str_count("The blue sky is blue", "blue")
2

julia> str_count("The blue sky is blue", r"blu")
2

julia> str_count("The blue sky is blue", "blue|sky")
3
```
"""

const docstring_str_squish  =
"""
    str_squish(column::String)

Squish a string, removing consecutive whitespace and replacing it with a single space, as well as removing leading and trailing whitespace.

#Arguments
`column`: The string to be squished.
Returns
A squished version of column.
# Examples
```jldoctest
julia> str_squish("  This    is a string   with   spaces   ")
"This is a string with spaces"

julia> str_squish("  Leading and trailing spaces   ")
"Leading and trailing spaces"
```
"""


const docstring_str_equal  =
"""
    str_equal(column::String, pattern::Union{String, Regex})

Check if a string exactly equals to a pattern, or for regular expressions, if the pattern can match the entire string.

# Arguments
- `column`: The string to be checked.
- `pattern`: The pattern to compare against. Can be a plain string or a Regex.
Returns
true if column equals to pattern (for plain strings) or if pattern can match the entire column (for Regex).
false otherwise.
# Examples
```jldoctest
julia> str_equal("hello", "hello")
true
```
"""

const docstring_str_subset  =
"""
    str_subset(column::String, pattern::Union{String, Regex})

Subset a string based on the presence of pattern. If the pattern exists within the string, the function will return the original string. If the pattern is not found within the string, the function will return an empty string.

# Arguments
- `column`: The string from which to extract the subset.
- `pattern`: The pattern to search for within the string. Can be a plain string or a Regex.
Returns
The original string if the pattern is found within it, otherwise an empty string.
# Examples
```jldoctest
julia> str_subset("Hello world!", "world")
"Hello world!"

julia> str_subset("Hello world!", "universe")
""
```
"""

const docstring_str_to_lower  =
"""
    str_to_lower(s::AbstractString)

Convert all characters in a string to lower case.

Arguments
- `s`: Input string.
Returns
String with all characters converted to lower case.
Examples
```jldoctest
julia> str_to_lower("Hello World!")
"hello world!"
```
"""

const docstring_str_to_upper  =
"""
    str_to_upper(s::AbstractString)

Convert all characters in a string to upper case.

Arguments
- `s`: Input string.
Returns
String with all characters converted to upper case.
Examples

```jldoctest
julia> str_to_upper("Hello World!")
"HELLO WORLD!"
```
"""


const docstring_str_remove_all  =
"""
    str_remove_all(column::String, pattern::Union{String, Regex})

Remove all occurrences of the pattern in the string.

# Arguments
- `column`: The string from which the pattern should be removed.
- `pattern`: The pattern which should be removed from the string. Can be a string or a regular expression.

Returns
A string with all occurrences of the pattern removed.

Examples
```jldoctest
julia> column = "I love tidier strings, I love tidier strings"
"I love tidier strings, I love tidier strings"

julia> str_remove_all(column, " strings")
"I love tidier , I love tidier "
```
"""

const docstring_str_remove  =
"""
    str_remove(column::String, pattern::Union{String, Regex})

Remove the first occurrence of the pattern in the string.

Arguments
- `column`: The string from which the pattern should be removed.
- `pattern`: The pattern which should be removed from the string. Can be a string or a regular expression.

Returns
A string with the first occurrence of the pattern removed.

Examples
```jldoctest
julia> column = "I love tidier strings strings"
"I love tidier strings strings"

julia> str_remove(column, " strings")
"I love tidier strings"
```
"""

const docstring_str_to_title  =
"""
    str_to_title(s::AbstractString)

Convert the first character of each word in a string to upper case.

Arguments
- `s`: Input string.

Returns
A string with the first character of each word converted to upper case.

Examples
```jldoctest
julia> str_to_title("hello world!")
"Hello World!"

julia> str_to_title("This is a title")
"This Is A Title"
```
"""

const docstring_str_to_sentence = 
"""
    str_to_sentence(s::AbstractString)

Convert the first character of each sentence in a string to upper case.

Arguments
- `s`: Input string.

Returns
A string with the first character of each sentence converted to upper case.

Examples
```jldoctest
julia> str_to_sentence("hello world!")
"Hello world!"

julia> str_to_sentence("a sentence mUst starT With A capital letter.")
"A sentence must start with a capital letter."
```
"""

const docstring_str_dup = 
"""
    str_dup(s::AbstractString, times::Int)

Duplicate the string `s` `times` times.

Arguments
- `s`: Input string.
- `times`: Number of times to duplicate the string.

Returns
A string with the string `s` duplicated `times` times.

Examples
```jldoctest
julia> str_dup("hello", 3)
"hellohellohello"
```
"""

const docstring_str_length = 
"""
    str_length(s::AbstractString)

Return the length of the string `s`.

Arguments
- `s`: Input string.

Returns
The length of the string `s`.

Examples
```jldoctest
julia> str_length("hello world! 😊")
14

julia> str_length("😊")
1
```
"""

const docstring_str_width = 
""" 
    str_width(s::AbstractString)

Return the width of the string `s`.

Arguments
- `s`: Input string.

Returns
The width of the string `s`.

Examples
```jldoctest
julia> str_width("hello world! 😊")
15

julia> str_width("😊")
2
```
"""

const docstring_str_trim = 
"""
    str_trim(s::AbstractString, side::String="both")

Removes all whitespace from the string `s` on the left and right side, or on both sides if `side` is "both".

Arguments
- `s`: Input string.
- `side`: The side(s) from which to remove whitespace. Can be "left", "right", or "both".

Returns
The string `s` with all whitespace removed on the left and right side, or on both sides if `side` is "both".

Examples
```jldoctest
julia> str_trim("  hello world! 😊  ")
"hello world! 😊"
```
"""

const docstring_str_unique =
"""
    str_unique(strings::AbstractVector{<:AbstractString}; ignore_case::Bool=false)

Remove duplicates from a vector of strings.

Arguments
- `strings`: Input vector of strings.
- `ignore_case`: Whether to ignore case when comparing strings. Default is `false`.

Returns
A vector of unique strings from the input vector.

Examples
```jldoctest
julia> str_unique(["apple", "banana", "pear", "banana", "Apple"])
4-element Vector{String}:
 "apple"
 "banana"
 "pear"
 "Apple"
```
"""

const docstring_word = 
"""
    word(string::AbstractString, start_index::Int=1, end_index::Int=start_index, sep::AbstractString=" ")

Extract a word from a string.

Arguments
- `string`: Input string.
- `start_index`: The starting index of the word. Default is 1.
- `end_index`: The ending index of the word. Default is `start_index`.
- `sep`: The separator between the start and end indices. Default is a space.

Returns
The extracted word from the string.

Examples
```jldoctest
julia> word("Jane saw a cat", 1)
1-element Vector{SubString{String}}:
 "Jane"

julia> word("Jane saw a cat", 2)
1-element Vector{SubString{String}}:
 "saw"

julia> word("Jane saw a cat", -1)
1-element Vector{SubString{String}}:
 "cat"

julia> word("Jane saw a cat", 2, -1)
3-element Vector{SubString{String}}:
 "saw"
 "a"
 "cat"
```
"""

const docstring_str_starts =
"""
    str_starts(string::Vector{T}, pattern::Union{AbstractString, Regex}; negate::Bool=false)

Check if a string starts with a certain pattern.

Arguments
- `string`: Input string.
- `pattern`: The pattern to check for. Can be a string or a regular expression.
- `negate`: Whether to negate the result. Default is `false`.

Returns
A vector of booleans indicating if the string starts with the pattern.

Examples
```jldoctest
julia> str_starts(["apple", "banana", "pear", "pineapple"], r"^p")  # [false, false, true, true]
4-element Vector{Bool}:
 0
 0
 1
 1
julia> str_starts(["apple", "banana", "pear", "pineapple"], r"^p", negate=true)  # [true, true, false, false]
4-element Vector{Bool}:
 1
 1
 0
 0
```
"""

const docstring_str_ends =
"""
    str_ends(string::Vector{T}, pattern::Union{AbstractString, Regex}; negate::Bool=false)

Check if a string ends with a certain pattern.

Arguments
- `string`: Input string.
- `pattern`: The pattern to check for. Can be a string or a regular expression.
- `negate`: Whether to negate the result. Default is `false`.

Returns
A vector of booleans indicating if the string ends with the pattern.

Examples
```jldoctest
julia> str_ends(["apple", "banana", "pear", "pineapple"], r"e\$")  # [true, false, false, true]
4-element Vector{Bool}:
 1
 0
 0
 1
julia> str_ends(["apple", "banana", "pear", "pineapple"], r"e\$", negate=true)  # [false, true, true, false]
4-element Vector{Bool}:
 0
 1
 1
 0
```
"""

const docstring_str_which =
"""
    str_which(string::Vector{T}, pattern::Union{AbstractString, Regex}; negate::Bool=false)

Returns the indices of strings where there's at least one match to the pattern.

# Arguments
- `string`: Input string.
- `pattern`: The pattern to check for. Can be a string or a regular expression.
- `negate`: Whether to negate the result. Default is `false`.

# Returns
An integer vector containing indices of matching strings.

# Examples
```jldoctest
julia> str_which(["apple", "banana", "pear", "pineapple"], r"a")  # [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4
julia> str_which(["apple", "banana", "pear", "pineapple"], r"a", negate=true)  # []
Int64[]
julia> str_which(["apple", "banana", "pear", "pineapple"], "a", negate=true)  # []
Int64[]
```
"""

const docstring_str_locate = 
"""
    str_locate(string::AbstractString, pattern::Union{AbstractString, Regex})

Returns the index of the first occurrence of a pattern in a string.

Arguments
- `string`: Input string.
- `pattern`: The pattern to search for. Can be a string or a regular expression.

A tuple `(start, end)` where `start` is the position at the start of the match and `end` is the position of the end.

Examples
```jldoctest
julia> fruit = ["apple", "banana", "pear", "pineapple"]; str_locate(fruit[1], "e")
(5, 5)

julia> fruit = ["apple", "banana", "pear", "pineapple"]; str_locate(fruit[2], "a")
(2, 2)
```
"""
const docstring_str_locate_all = 
"""
    str_locate_all(string::AbstractString, pattern::Union{AbstractString, Regex})

Returns the indices of all occurrences of a pattern in a string.

Arguments
- `string`: Input string.
- `pattern`: The pattern to search for. Can be a string or a regular expression.

A vector of tuples `(start, end)` where `start` is the position at the start of the match and `end` is the position of the end.

Examples
```jldoctest
julia> fruit = ["apple", "banana", "pear", "pineapple"]; str_locate_all(fruit[1], "e")
1-element Vector{Tuple{Int64, Int64}}:
 (5, 5)

julia> fruit = ["apple", "banana", "pear", "pineapple"]; str_locate_all(fruit[2], "a")
3-element Vector{Tuple{Int64, Int64}}:
 (2, 2)
 (4, 4)
 (6, 6)
```
"""

const docstring_str_replace_missing = 
"""
    str_replace_missing(string::AbstractVector{Union{Missing,String}}, replacement::String="missing")

Replaces missing values in a vector with a specified string.

Arguments
- `string`: Input vector of strings.
- `replacement`: The string to replace missing values with. Default is "missing".

Returns
The vector of strings with missing values replaced.

Examples
```jldoctest
julia> str_replace_missing(["apple", missing, "pear", "pineapple"])
4-element Vector{String}:
 "apple"
 "missing"
 "pear"
 "pineapple"
```
"""

const docstring_str_conv = 
"""
    str_conv(string::Union{String,Vector{UInt8}}, encoding::String)

Converts a string to a different encoding.

Arguments
- `string`: Input string.
- `encoding`: A String that specifies the encoding to use.

Returns
The converted string.

Examples
```jldoctest
julia> str_conv("Hello, World!", "UTF-8")
"Hello, World!"

julia> str_conv("Hello, World!", "ASCII")
"Hello, World!"

julia> str_conv("Héllo, Wörld!", "ISO-8859-1")
"Héllo, Wörld!"

julia> str_conv([0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21], "UTF-8")
"Hello, world!"
```
"""

const docstring_str_like = 
"""
    str_like(string::AbstractVector{String}, pattern::String; ignore_case::Bool = true)

Detect a pattern in each string of the input vector using SQL-like pattern matching.

Arguments
- `string`: Input string.
- `pattern`: The pattern to check for. Can be a string or a regular expression.
- `ignore_case`: Whether to ignore case when matching. Default is `true`.

Returns
A vector of booleans indicating if the string matches the pattern.

```jldoctest
julia> str_like(["Hello", "world", "HELLO", "WORLD"], "H_llo")
4-element Vector{Bool}:
 1
 0
 1
 0
```
"""

const docstring_str_c =
"""
    str_c(strings::AbstractVector; sep::AbstractString="")

Joins a vector of strings into a single string.

Arguments
- `strings`: Input strings.
- `sep`: The separator between the strings. Default is an empty string.

Returns
The joined string.

Examples
```jldoctest
julia> str_c(["apple", "banana", "pear", "pineapple"])
"applebananapearpineapple"
```
"""

const docstring_str_wrap =
"""
    str_wrap(string::AbstractString; width::Integer=80, indent::Integer=0, exdent::Integer=0, whitespace_only::Bool=true)::String

Wraps a string into multiple lines.

Arguments
- `string`: Input string.
- `width`: The maximum width of each line. Default is 80.
- `indent`: The number of spaces to indent each line. Default is 0.
- `exdent`: The number of spaces to exdent each line. Default is 0.
- `whitespace_only`: Whether to only wrap on whitespace. Default is true.

Returns
The wrapped string.

Examples
```jldoctest
julia> str_wrap("This is an example text that should be wrapped based on the given width and breaking rules.", width=20, whitespace_only=true)
"This is an example\ntext that should be\nwrapped based on the\ngiven width and\nbreaking rules."

```
"""