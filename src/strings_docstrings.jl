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
"A sentence must start With a capital letter."
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
"""
