# TidierStrings.jl

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/TidierOrg/TidierStrings.jl/blob/main/LICENSE)
[![Docs: Latest](https://img.shields.io/badge/Docs-Latest-blue.svg)](https://tidierorg.github.io/TidierStrings.jl/dev)
[![Build Status](https://github.com/TidierOrg/TidierStrings.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/TidierOrg/TidierStrings.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/Tidier&label=Downloads)](https://pkgs.genieframework.com?packages=TidierStrings)

<img src="/docs/src/assets/TidierStrings_logo.png" align="right" style="padding-left:10px;" width="150"/>

## What is TidierStrings.jl

`TidierStrings.jl `is a 100% Julia implementation of the R stringr package. 

`TidierStrings.jl` has one main goal: to implement stringr's straightforward syntax and of ease of use for Julia users. While this package was developed to work seamlessly with `TidierData.jl` functions and macros, it also works independently as a standalone package. 

## Installation

For the stable version:

```
] add TidierStrings
```

The `]` character starts the Julia [package manager](https://docs.julialang.org/en/v1/stdlib/Pkg/). Press the backspace key to return to the Julia prompt.

or


For the development version:

```julia
using Pkg
Pkg.add(url = "https://github.com/TidierOrg/TidierStrings.jl.git")
```

## What functions does TidierStrings.jl support?

TidierStrings.jl currently supports: 

- `str_detect()`
- `str_replace()`
- `str_replace_all()`
- `str_removal_all()`
- `str_remove()`
- `str_count()`
- `str_squish()`
- `str_equal()`
- `str_to_upper()`
- `str_to_lower()`
- `str_subset()`

## Examples

```julia
using Tidier
using TidierStrings
df = DataFrame(
  Names = ["Alice", "Bob", "Charlie", "Dave", "Eve", "Frank", "Grace"],
  City = ["New York        2019-20", "Los    \n\n\n\n\n\n    Angeles 2007-12 2020-21", "San Antonio 1234567890         ", "       New York City", "LA         2022-23", "Philadelphia            2023-24", "San Jose               9876543210"],
  Occupation = ["Doctor", "Engineer", "Final Artist", "Scientist", "Physician", "Lawyer", "Teacher"],
  Description = ["Alice is a doctor in New York",
                 "Bob is is is an engineer in Los Angeles",
                 "Charlie is an artist in Chicago",
                 "Dave is a scientist in Houston",
                 "Eve is a physician  in Phoenix",
                 "Frank is a lawyer in Philadelphia",
                 "Grace is a teacher in San Antonio"]
)
```

```
7×4 DataFrame
 Row │ Names    City                               Occupation    Description                       
     │ String   String                             String        String                            
─────┼─────────────────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York        2019-20            Doctor        Alice is a doctor in New York
   2 │ Bob      Los    \n\n\n\n\n\n    Angeles 2…  Engineer      Bob is is is an engineer in Los …
   3 │ Charlie  San Antonio 1234567890             Final Artist  Charlie is an artist in Chicago
   4 │ Dave            New York City               Scientist     Dave is a scientist in Houston
   5 │ Eve      LA         2022-23                 Physician     Eve is a physician  in Phoenix
   6 │ Frank    Philadelphia            2023-24    Lawyer        Frank is a lawyer in Philadelphia
   7 │ Grace    San Jose               9876543210  Teacher       Grace is a teacher in San Antonio
```

`str_squish()`: Removes leading and trailing white spaces from a string and also replaces consecutive white spaces in between words with a single space. It will also remove new lines.

```julia
df = @chain df begin
    @mutate(City = str_squish(City))
end
```

```
7×4 DataFrame
 Row │ Names    City                         Occupation    Description                       
     │ String   String                       String        String                            
─────┼───────────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York 2019-20             Doctor        Alice is a doctor in New York
   2 │ Bob      Los Angeles 2007-12 2020-21  Engineer      Bob is is is an engineer in Los …
   3 │ Charlie  San Antonio 1234567890       Final Artist  Charlie is an artist in Chicago
   4 │ Dave     New York City                Scientist     Dave is a scientist in Houston
   5 │ Eve      LA 2022-23                   Physician     Eve is a physician  in Phoenix
   6 │ Frank    Philadelphia 2023-24         Lawyer        Frank is a lawyer in Philadelphia
   7 │ Grace    San Jose 9876543210          Teacher       Grace is a teacher in San Antonio
```

#### Support Regex: `str_detect`, `str_replace`, `str_replace_all`, `str_remove`, `str_remove_all`, `str_count`, `str_equal`, and `str_subset` 

#### `str_detect()`
'str_detect()' checks if a pattern exists in a string. It takes a string and a pattern as arguments and returns a boolean indicating the presence of the pattern in the string. This can be used inside of `@filter`, `@mutate`, `if_else()` and `case_when()`. `str_detect` supports logical operators | and &. 
 case_when() with filter() and str_detect()

```julia
@chain df begin
    @mutate(Occupation = if_else(str_detect(Occupation, "Doctor | Physician"), "Physician", Occupation))
    @filter(str_detect(Description, "artist | doctor"))
end
```

```
 Row │ Names    City                    Occupation    Description                     
     │ String   String                  String        String                          
─────┼────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York 2019-20        Physician     Alice is a doctor in New York
   2 │ Charlie  San Antonio 1234567890  Final Artist  Charlie is an artist in Chicago
```

```julia
@chain df begin
    @mutate(state = case_when(str_detect(City, "NYC | New York") => "NY", 
                              str_detect(City, "LA | Los Angeles | San & Jose") => "CA", 
                              true => "other"))
end
```

```
7×5 DataFrame
 Row │ Names    City                         Occupation    Description                        state  
     │ String   String                       String        String                             String 
─────┼───────────────────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York 2019-20             Doctor        Alice is a doctor in New York      NY
   2 │ Bob      Los Angeles 2007-12 2020-21  Engineer      Bob is is is an engineer in Los …  CA
   3 │ Charlie  San Antonio 1234567890       Final Artist  Charlie is an artist in Chicago    other
   4 │ Dave     New York City                Scientist     Dave is a scientist in Houston     NY
   5 │ Eve      LA 2022-23                   Physician     Eve is a physician  in Phoenix     CA
   6 │ Frank    Philadelphia 2023-24         Lawyer        Frank is a lawyer in Philadelphia  other
   7 │ Grace    San Jose 9876543210          Teacher       Grace is a teacher in San Antonio  CA
```

#### `str_replace()` 
Replaces the first occurrence of a pattern in a string with a specified text. Takes a string, pattern to search for, and the replacement text as arguments. It also supports the use of regex and logical operator | . This is in contrast to str_replace_all() which will replace each occurence of a match within a string.

```julia
@chain df begin
  @mutate(City = str_replace(City, r"\s*20\d{2}-\d{2,4}\s*", " ####-## "))
  @mutate(Description = str_replace(Description, "is | a", "will become "))
end
```

```
7×4 DataFrame
 Row │ Names    City                         Occupation    Description                       
     │ String   String                       String        String                            
─────┼───────────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York ####-##             Doctor        Alice will become a doctor in Ne…
   2 │ Bob      Los Angeles ####-## 2020-21  Engineer      Bob will become is is an enginee…
   3 │ Charlie  San Antonio 1234567890       Final Artist  Charlie will become an artist in…
   4 │ Dave     New York City                Scientist     Dave will become a scientist in …
   5 │ Eve      LA ####-##                   Physician     Eve will become a physician in P…
   6 │ Frank    Philadelphia ####-##         Lawyer        Frank will become a lawyer in Ph…
   7 │ Grace    San Jose 9876543210          Teacher       Grace will become a teacher in S…
```


#### `str_remove` and `str_remove_all` 
These remove the first match occurrence or all occurences, respectively.

```julia
@chain df begin
    @mutate(split = str_remove_all(Description, "is"))
end
```

```
7×5 DataFrame
 Row │ Names    City                         Occupation    Description                        split                          
     │ String   String                       String        String                             String                         
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York 2019-20             Doctor        Alice is a doctor in New York      Alice a doctor in New York
   2 │ Bob      Los Angeles 2007-12 2020-21  Engineer      Bob is is is an engineer in Los …  Bob an engineer in Los Angeles
   3 │ Charlie  San Antonio 1234567890       Final Artist  Charlie is an artist in Chicago    Charlie an artist in Chicago
   4 │ Dave     New York City                Scientist     Dave is a scientist in Houston     Dave a scientist in Houston
   5 │ Eve      LA 2022-23                   Physician     Eve is a physician  in Phoenix     Eve a physician in Phoenix
   6 │ Frank    Philadelphia 2023-24         Lawyer        Frank is a lawyer in Philadelphia  Frank a lawyer in Philadelphia
   7 │ Grace    San Jose 9876543210          Teacher       Grace is a teacher in San Antonio  Grace a teacher in San Antonio
```

#### `str_equal()`
Checks if two strings are exactly the same. Takes two strings as arguments and returns a boolean indicating whether the strings are identical.

```julia
@chain df begin
    @mutate(Same_City = case_when(str_equal(City, Occupation) => "Yes", 
                                  true => "No"))
end
```
```
 Row │ Names    City                         Occupation    Description                        Same_City 
     │ String   String                       String        String                             String    
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ Alice    New York 2019-20             Doctor        Alice is a doctor in New York      No
   2 │ Bob      Los Angeles 2007-12 2020-21  Engineer      Bob is is is an engineer in Los …  No
   3 │ Charlie  San Antonio 1234567890       Final Artist  Charlie is an artist in Chicago    No
   4 │ Dave     New York City                Scientist     Dave is a scientist in Houston     No
   5 │ Eve      LA 2022-23                   Physician     Eve is a physician  in Phoenix     No
   6 │ Frank    Philadelphia 2023-24         Lawyer        Frank is a lawyer in Philadelphia  No
   7 │ Grace    San Jose 9876543210          Teacher       Grace is a teacher in San Antonio  No
```

#### `str_to_upper` and `str_to_lower`
These will take a string and convert it to all uppercase or lowercase.

```julia
@chain df begin
    @mutate(Names = str_to_upper(Names))
    @select(Names)
end
```

```
7×1 DataFrame
 Row │ Names   
     │ String  
─────┼─────────
   1 │ ALICE
   2 │ BOB
   3 │ CHARLIE
   4 │ DAVE
   5 │ EVE
   6 │ FRANK
   7 │ GRACE
```
